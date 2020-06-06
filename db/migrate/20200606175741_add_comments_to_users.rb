class AddCommentsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :user, null: false
    add_foreign_key :comments, :users, on_delete: :cascade
  end
end
