
class UserFavoriteApp < ApplicationRecord
    belongs_to :follower, foreign_key: :user_id, class_name: "User"
    belongs_to :favorite_app, foreign_key: :app_id, class_name: "App"
end