# Tom Lai and Andre Haas

class Invite < ActiveRecord::Base
  belongs_to :household
  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :household_id, presence: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validate :users_can_only_be_invited_once_by_household

  private

    def users_can_only_be_invited_once_by_household
      if household and
         !(household.invites.where(email: email).empty? ||
         (household.invites.count == 1 && household.invites.include?(self)))
        errors.add(:email, 'already invited by this household')
      end
    end

end
