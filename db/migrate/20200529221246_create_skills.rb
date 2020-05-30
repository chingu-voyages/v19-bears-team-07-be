class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.timestamps
    end

    create_table :skills_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :skill
    end
  end
end
