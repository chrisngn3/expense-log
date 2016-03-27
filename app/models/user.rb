class User < ActiveRecord::Base
	# attr_accessor :name, :amount_paid
	serialize :owe, Hash
	
	has_many :expenses

	# each user's name must be unique
	validates :name, uniqueness: true
end
