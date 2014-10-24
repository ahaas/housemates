# Tom Lai, Andre Haas

class TransactionsController < ApplicationController

  def show
    @transactions = current_user.transactions_as_payer + 
    current_user.transactions_as_payee
    @transactions.uniq!
    @transactions.sort_by!(&:created_at).reverse!
    render 'show'
  end

  def new_item
  end

  def new_payback
    @users = current_user.housemates
  end

  def create
    if params[:commit] == 'Add item'
      create_new_item
    elsif params[:commit] == 'Pay back'
      create_new_paid_back
    end
    redirect_to transactions_show_path
  end

  def create_new_item
    # create transaction group
    transaction_group = TransactionGroup.new(
      name: params[:name], 
      total_amount: params[:amount])
    if not transaction_group.save
      flash[:danger] = transaction_group.errors.messages.keys[0].to_s + " " + 
        transaction_group.errors.messages.values[0][0]
    else
      # create transaction
      params[:payers].each do |uid|
        payer = User.find_by_id(uid)
        t = Transaction.new(
          payer:payer, 
          payee:current_user, 
          household:current_user.household,
          transaction_group: transaction_group,
          is_payback: params[:is_payback].to_i, 
          amount: params[:amount].to_f / params[:payers].count)
        if not t.save
          flash[:danger] = t.errors.messages.keys[0].to_s + " " + 
          t.errors.messages.values[0][0]
          break
        end
      end
    end
  end

  def create_new_paid_back
    transaction_group = TransactionGroup.new(
      name: 'Paid back', 
      total_amount: params[:amount])
    if not transaction_group.save
      flash[:danger] = transaction_group.errors.messages.keys[0].to_s + " " + 
        transaction_group.errors.messages.values[0][0]
    else
      # create transaction
      payer = User.find_by_id(params[:user_id])
      t = Transaction.new(
        payer:payer, 
        payee:current_user, 
        household:current_user.household,
        transaction_group: transaction_group,
        is_payback: params[:is_payback].to_i, 
        amount: params[:amount].to_f)
      if not t.save
        flash[:danger] = t.errors.messages.keys[0].to_s + " " + 
        t.errors.messages.values[0][0]
      end
    end
  end
end