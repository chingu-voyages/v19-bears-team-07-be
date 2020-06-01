class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
        t.belongs_to :app
        t.belongs_to :user
        t.integer :score

        t.timestamps
    end
  end
end
