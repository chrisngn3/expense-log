class UsersController < ApplicationController
	def index
		@users = User.all.order(:id)
	end

	def show
		@user = User.find(params[:id])
	end

	private
	def print_hash hash
		s = ""
		hash
		return s
	end

end # UsersController
