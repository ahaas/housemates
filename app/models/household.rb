# Andre Haas

class Household < ActiveRecord::Base
  has_many :users
  has_many :invites
  has_many :events
  has_many :announcements
  validates :name, presence: true, length: {maximum: 64}
end
