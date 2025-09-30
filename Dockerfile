# syntax = docker/dockerfile:1

# ---- Base image ----
ARG RUBY_VERSION=3.3.4
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# ---- Build stage ----
FROM base as build

# Install build dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config nodejs npm libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.5.18 && bundle install --jobs 4 --retry 3

# Copy app source
COPY . .

# Fix permission issues
RUN chmod +x bin/*

# Precompile bootsnap + assets with dummy key
RUN bundle exec bootsnap precompile --gemfile
# Precompile assets without forcing DB connection
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile || echo "Skipping DB connection for assets"


# ---- Final stage ----
FROM base

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libsqlite3-0 libvips postgresql-client nodejs && \
    rm -rf /var/lib/apt/lists/*

# Copy built app + gems
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Add non-root user
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

EXPOSE 3000

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
