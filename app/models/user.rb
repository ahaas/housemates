# Andre Haas, Tom Lai

class User < ActiveRecord::Base
  attr_accessor :remember_token, :reset_token
  belongs_to :household
  has_many :transactions_as_payer, class_name: 'Transaction', foreign_key: 'payer_id'
  has_many :transactions_as_payee, class_name: 'Transaction', foreign_key: 'payee_id'
  has_many :events
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 127 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 6, allow_blank: true

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def housemates
    return household.users - [self]
  end

  def invites
    return Invite.where(email: email)
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def create_reset_digest
    reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    PasswordResetMailer.password_reset_email(self).deliver
  end

  def reset_password(token, password, password_confirmation)
    if self.reset_digest == token and self.password_reset_not_expired?
      self.password = password
      self.password_confirmation = password_confirmation
      if self.save
        self.reset_digest = nil
        self.reset_sent_at = nil
        self.save
        return 0
      end
    end
    return -1
  end

  # Returns true if a password reset has expired.
  def password_reset_not_expired?
    self.reset_sent_at > 2.hours.ago
  end

  def transactions_with_user(user)
    @transactions = []
    @transactions += transactions_as_payee.select{|t| t.payer == user}
    @transactions += transactions_as_payer.select{|t| t.payee == user}
    @transactions.uniq!
    @transactions.sort_by!(&:created_at).reverse!
    return @transactions
  end

end
