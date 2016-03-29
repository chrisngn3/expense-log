class ExpensesController < ApplicationController

	def index
		@expenses = Expense.all
		@users = User.all.order(:id)
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
		split_between = @expense.split_between.keep_if { |name| !name.blank? }
		# p "a = #{a}"
		if (split_between.size > 0)
			amount = @expense.cost / split_between.size
			split_expense @expense.user, split_between, amount
		end

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
		# @expense = Expense.find(params[:id])

		# remove amount_paid
		update_amount_paid @expense.user_id, -@expense.cost

		# remove split_between
		remove_expense @expense

		# @expense.destroy # do I need this?
		flash[:success] = "Expense removed!"
		redirect_to action: 'index'
	end

	private
	def expense_params
		# params.require(:expense).permit(:name, :cost, :user_id, :split_between)
		params.require(:expense).permit! # permit all params
	end

	# remove all splitting once an expense is destroyed
	def remove_expense expense
		paid_by = expense.user
		split_between = expense.split_between

		if (split_between.size > 0)
			amount = expense.cost / split_between.size

			split_between.each do |name|
				current_user = User.where(name: name).first
				amount_copy = amount

				if current_user.name != paid_by.name
					# the person who paid for the expense does not owe himself so nothing to remove

					if current_user.owe[paid_by.name] < amount_copy
						# the current user owes less than the person who paid for this expense
						# the person who paid owes the difference
						amount_copy -= current_user.owe[paid_by.name]
						current_user.owe[paid_by.name] = 0.0
					else
						# all debts are cancelled out
						current_user.owe[paid_by.name] -= amount_copy
						amount_copy = 0.0
					end
					current_user.save

					if amount_copy > 0.0
						# the remaining expense that the person who paid for this expense failed to cancelled out
						paid_by.owe[current_user.name] += amount_copy
					end
					paid_by.save
				end # current_user.name != paid_by.name
			end  # split_between.each
		end # split_between.size > 0
	end # remove_expense

	# add splitting if there are any for an expense
	def split_expense paid_by, split_between, amount
		if split_between.size > 0
			# if there is anything to split

			split_between.each do |name|
				# first and only because names are unique
				current_user = User.where(name: name).first 
				amount_copy = amount

				p "cost = #{amount}"
				p "current_user = #{current_user.name}"
				p "paid_by = #{paid_by.name}"

				if current_user.name != paid_by.name
					# the person who paid does not owe himself

					if paid_by.owe.key?(current_user.name)
						# if the other person owes the current user, cancel out the debt

						if paid_by.owe[current_user.name] < amount_copy
							# if what the person who paid for the expense owe the current user 
							# is less than the amount the current user owe them 
							# then current owe them the difference
			        amount_copy -= paid_by.owe[current_user.name]
			        paid_by.owe[current_user.name] = 0
			      else
			      	# if what the person who paid for the expense owe the current user
			      	# is greater than or equal to the amount the current user owe them
          		# subtract the amount current user owe them from the amount they owe the current user
          		paid_by.owe[current_user.name] -= amount_copy
          		amount_copy = 0.0
						end
						paid_by.save
					end # paid_by.owe.key?(current_user.name)

					if amount_copy > 0.0
						if current_user.owe.key?(paid_by.name)
							current_user.owe[paid_by.name] += amount_copy
						else
							current_user.owe[paid_by.name] = amount_copy
						end
					end # amount > 0
				end # current_user.name != paid_by.name
				current_user.save
			end # split_between.each
		end # a.size > 0
	end # split_expense

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
