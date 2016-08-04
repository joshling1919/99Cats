class RemoveUnqiueConstraint < ActiveRecord::Migration
  def change
    remove_column :tokens, :user_id
    add_column :tokens, :user_id, :integer

    add_index :tokens, :user_id 
  end
end
