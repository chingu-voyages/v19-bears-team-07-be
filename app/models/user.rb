class User < ApplicationRecord
  has_many :apps
  # belongs_to :teams, optional: true
  has_many :user_favorite_apps
  has_many :favorite_apps, through: :user_favorite_apps 
  has_one_attached :image

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
