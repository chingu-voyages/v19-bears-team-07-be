class App < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category, optional: true
  has_many :tags

  has_many :user_favorite_apps
  has_many :followers, through: :user_favorite_apps
end
