# syntax = docker/dockerfile:1

# Ruby version should match your Gemfile
ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim as base

# Set working directory
WORKDIR /rails

# Environment variables for Rails
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test"

# ---- Build stage ----
FROM base as build

# Install system dependencies (needed for gems like pg, bootsnap, etc.)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libvips \
      pkg-config \
      libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.18 && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy app source
COPY . .

# Precompile bootsnap cache
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets with dummy key so build won’t fail
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ---- Final stage ----
FROM base

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libsqlite3-0 \
      libvips \
      postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy gems and app from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Create non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the DB (migrations etc.)
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port for Railway
EXPOSE 3000

# Start Puma server
CMD ["./bin/rails", "server"]
