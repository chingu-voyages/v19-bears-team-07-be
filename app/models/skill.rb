class Skill < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, optional: true
end
