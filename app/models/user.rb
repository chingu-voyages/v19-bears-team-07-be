class User < ApplicationRecord
  has_many :apps
  # belongs_to :teams, optional: true
  has_many :user_favorite_apps
  has_many :favorite_apps, through: :user_favorite_apps 

  has_many :ratings
  has_many :reviewed_apps, through: :ratings

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
