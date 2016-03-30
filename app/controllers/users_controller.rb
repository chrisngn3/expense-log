class UsersController < ApplicationController
	def index
		@users = User.all.order(:id)
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		init_user @user

		if @user.save
			flash[:success] = "User added!"
			redirect_to '/users'
		else
			render 'new'
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :amount_paid, :owe)
	end

	def init_user user
		# set hash
		User.all.each do |u|
			# set for the new user
			user.owe[u.name] = 0.0

			# add the new user to the old users
			u.owe[user.name] = 0.0 unless u.owe.key?(user.name)
			u.save
		end

		# set amount_paid
		user.amount_paid = 0.0
	end

end # UsersController
