class Rating < ApplicationRecord
    belongs_to :reviewer, foreign_key: :user_id, class_name: "User"
    belongs_to :reviewed_app, foreign_key: :app_id, class_name: "App"
end