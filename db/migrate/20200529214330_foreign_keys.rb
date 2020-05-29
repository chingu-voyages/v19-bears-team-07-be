class ForeignKeys < ActiveRecord::Migration[6.0]
  def change
      remove_foreign_key :comments, :apps
      add_foreign_key :comments, :apps, on_delete: :cascade
  end
end
