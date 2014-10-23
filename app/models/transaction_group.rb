# Tom Lai

class TransactionGroup < ActiveRecord::Base
  before_save { self.total_amount = self.total_amount.round(2) }
  validates :name, presence: true, length: { maximum: 127 }
  validates :total_amount, presence: true
  validates_numericality_of :total_amount, greater_than: 0
end