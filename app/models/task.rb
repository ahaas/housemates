#Kevin Sung

class Task < ActiveRecord::Base
    belongs_to :user
    belongs_to :household
    validates :household_id, presence: true
    validates :name, presence: true
    validates :completed, :inclusion => {:in => [true, false]}
end
