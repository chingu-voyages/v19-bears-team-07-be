class CreateUserFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :user_favorite_apps do |t|
      t.belongs_to :user
      t.belongs_to :app
      t.timestamps
    end
  end
end
