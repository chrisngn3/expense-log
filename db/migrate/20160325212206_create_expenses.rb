class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
    	t.string :name
    	# t.string :description
    	t.float :cost
      t.references :user, foreign_key: true
     	t.integer :user_id
      
      # an array of the name of the people to split with
      t.text :split_with 
      t.timestamps null: false
    end
  end
end