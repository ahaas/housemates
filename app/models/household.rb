# Andre Haas

class Household < ActiveRecord::Base
  has_many :users
  validates :name, presence: true, length: {maximum: 64}
end
