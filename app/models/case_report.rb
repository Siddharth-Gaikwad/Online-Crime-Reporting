class CaseReport < ApplicationRecord
  belongs_to :user
  belongs_to :branch, optional: true

  has_one_attached :evidence_image


  validates :title, :description, :phone_no, presence: true


  before_create :assign_nearest_branch, if: -> { branch_id.blank? && latitude.present? && longitude.present? }

  private

  def assign_nearest_branch
    self.branch = Branch.nearest_branch(latitude, longitude)
  end

end
