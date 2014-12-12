  # Tom Lai, Andre Haas, Opal Kale

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
      if params[:payers].length == 1 and 
        User.find_by_id(params[:payers].first) == current_user
        flash[:danger] = "transaction is not created since you are the only payer and payee"
        return
      end
      params[:payers].each do |uid|
        payer = User.find_by_id(uid)
        if not payer == current_user
          # create transaction record
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
          # update balance
          b = Balance.transfer(current_user, payer, t.amount)
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
      payee = User.find_by_id(params[:user_id])
      t = Transaction.new(
        payer:current_user, 
        payee:payee, 
        household:current_user.household,
        transaction_group: transaction_group,
        is_payback: params[:is_payback].to_i, 
        amount: params[:amount].to_f)
      if not t.save
        flash[:danger] = t.errors.messages.keys[0].to_s + " " + 
        t.errors.messages.values[0][0]
      end
      # update balance
      b = Balance.transfer(payee, current_user, params[:amount])
    end
  end

  def individual_history
    if not params.has_key? :user_id
      redirect_to transactions_show_path
      return
    end
    @user = User.find_by(id: params[:user_id])
    if @user == nil or current_user == @user or 
      @user.household != current_user.household
      redirect_to transactions_show_path 
      return
    end
    @transactions = current_user.transactions_with_user(@user)
  end
end