class Expense < ActiveRecord::Base
	# attr_accessor :user_id
	serialize :split_between, Array

	belongs_to :user

	# each expense's name must be unique
	validates :name, uniqueness: true
	validates :user_id, presence: true
	validates :cost, :numericality => { greater_than: 0 }
end
