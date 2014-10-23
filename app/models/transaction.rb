# Tom Lai

class Transaction < ActiveRecord::Base
  belongs_to :payer, class_name: 'User', foreign_key: 'payer_id'
  belongs_to :payee, class_name: 'User', foreign_key: 'payee_id'
  belongs_to :household
  belongs_to :transaction_group

  before_save {self.amount = self.amount.round(2)} 

  validates :payer_id, presence: true 
  validates :payee_id, presence: true 
  validates :household_id, presence: true 
  validates :transaction_group_id, presence: true
  validates :is_payback, :inclusion => {:in => [true, false]}
  validates :amount, presence: true
  validates_numericality_of :amount, greater_than: 0
end
