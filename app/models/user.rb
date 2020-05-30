class User < ApplicationRecord
  # belongs_to :teams, optional: true
  has_many :apps
  has_many :user_favorite_apps
  has_many :favorite_apps, through: :user_favorite_apps 
  has_and_belongs_to_many :skills

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
