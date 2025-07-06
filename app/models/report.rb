class Report < ApplicationRecord
  belongs_to :reportable, polymorphic: true
  belongs_to :user

  validates :reason, presence: true, length: {minimum: 10 }

  def self.ransackable_associations(auth_object = nil)
    ["user", "reportable"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "reason", "reportable_id", "reportable_type", "created_at", "updated_at"]
  end
end
