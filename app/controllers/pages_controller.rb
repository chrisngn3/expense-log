class PagesController < ApplicationController
	def welcome
		@expenses = Expense.all
		@users = User.all.order(:id)
	end
end
