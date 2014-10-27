# Tom Lai, Andre Haas

class Balance < ActiveRecord::Base
  belongs_to :user1, class_name: 'User', foreign_key: 'user1_id'
  belongs_to :user2, class_name: 'User', foreign_key: 'user2_id'

  before_save {self.amount = self.amount.round(2)} 

  validates :user1_id, presence: true
  validates :user2_id, presence: true 
  validates :amount, presence: true
  validate :users_cannot_be_the_same,
           :duplicate_balance_cannot_be_created

  # represents how much user2 owes user1
  def Balance.get(user1, user2)
    balance = Balance.get_balance(user1, user2)
    if balance.user1 == user1
      return balance.amount
    elsif balance.user2 == user1
      return -balance.amount
    else
      return nil
    end
  end

  def Balance.transfer(user1, user2, amount)
    balance = Balance.get_balance(user1, user2)
    if balance.user1 == user1
      balance.amount += amount.to_f
    elsif balance.user2 == user1
      balance.amount -= amount.to_f
    end
    balance.save
  end

  def Balance.get_balance(user1, user2)
    balance1 = Balance.find_by(user1: user1, user2: user2)
    balance2 = Balance.find_by(user1: user2, user2: user1)
    if balance1
      return balance1
    elsif balance2
      return balance2
    else
      raise "error! cannot find balance!"
    end
  end

  private

    def users_cannot_be_the_same
      if user1.id == user2.id
        errors.add(:users, "cannot be the same")
      end
    end

    def duplicate_balance_cannot_be_created
      if not id
        balance1 = Balance.find_by(user1: user1, user2: user2)
        balance2 = Balance.find_by(user1: user2, user2: user1)
        if balance1 or balance2
          errors.add(:balance, "already exists")
        end
      end
    end
end
