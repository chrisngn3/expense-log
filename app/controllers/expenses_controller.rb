class ExpensesController < ApplicationController

	def index
		@expenses = Expense.all
		@users = User.all
	end

	def new
		print_params
		
		@expense = Expense.new
	end

	def create
		@expense = Expense.new(expense_params)

		# user must increment his amount_paid when he pays for a new expense
		update_amount_paid @expense.user_id, @expense.cost

		# user must split the cost of the expense with the appropriate parties
		split_expense(@expense)

		if @expense.save
			flash[:success] = "Expense added!"
			redirect_to action: 'index' # same as: redirect_to '/expenses'
		else
			render 'new'
		end
	end

	def show
		@expense = Expense.find(params[:id])
	end

	def edit
		@expense = Expense.find(params[:id])
	end

	def update
		@expense = Expense.find params[:id]

		# print_params

		old_cost = @expense.cost
		old_user_id = @expense.user_id

		new_cost = params[:expense][:cost].to_f
		new_user_id = params[:expense][:user_id].to_i

		if new_cost > 0.0
			if old_user_id != new_user_id
				# user is different
				# remove the old_cost from the old user
				update_amount_paid old_user_id, -old_cost

				# add the new_cost to the new user
				update_amount_paid new_user_id, new_cost

			elsif old_cost != new_cost
				# cost is different but user is the same
				# update the difference in cost since the user is unchanged
				update_amount_paid old_user_id, new_cost - old_cost

			else
				# nothing has change so redirect and return early from method
				redirect_to action: 'index'
				return
			end # scenarios
		end # cost > 0.0

    if @expense.update_attributes(expense_params)
    	flash[:success] = "Expense updated!"
      # redirect_to action: 'show', id: @expense.id
      redirect_to action: 'index'
    else
      render 'edit'
    end
	end # update

	def destroy
		@expense = Expense.destroy(params[:id])

		# remove amount_paid
		update_amount_paid @expense.user_id, -@expense.cost

		# remove split_with

		@expense.destroy
		flash[:success] = "Expense removed!"
		redirect_to '/expenses'
	end

	private
	def expense_params
		params.require(:expense).permit(:name, :cost, :user_id)
	end

	def split_expense expense

	end

	def update_paid_by 

	end

	def update_amount_paid user_id, cost
		user = User.find user_id
		user.amount_paid += cost
		user.save
	end

	def print_params
		p "params = #{params}"
		p "params[:expense] = #{params[:expense]}"
	end
end
