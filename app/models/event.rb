class Event < ActiveRecord::Base
  belongs_to :household
  belongs_to :user

  validates :household_id, presence: true
  validates :user_id, presence: true
  validates :name, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :end_at_after_start_at

  private

    def end_at_after_start_at
      if end_at < start_at then
        errors.add(:end_at, "must be after start time")
      end
    end
end
