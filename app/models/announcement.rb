# Tom Lai
class Announcement < ActiveRecord::Base
  belongs_to :user
  belongs_to :household
  validates :user_id, presence: true
  validates :household_id, presence: true
  validates :text, presence: true
end