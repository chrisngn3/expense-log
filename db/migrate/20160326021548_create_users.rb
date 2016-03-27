class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.float :amount_paid
    	
    	# a hash mapping of people and amounts that you owe them
    	t.text :owe 
      t.timestamps null: false
    end
  end
end
