Portfolio = Struct.new(:apps)
SkillsList = Struct.new(:skills)

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :portfolio, :skills]
  before_action :authenticate_user!, except: [:index, :show, :portfolio, :skills]


  # GET /users
  def index
    @users = User.all
    @users.each do |user|
      if user.image.attached?
        user.img = url_for(user.image)
      end
    end
    json_response(@users)
  end

  # GET /user/:id
  def show
    if @user.image.attached?
      @user.img = url_for(@user.image)
    end
    json_response(@user)
  end

  # POST /users
  def create
    @user = User.create(user_params)
    json_response(@user, :created)
  end

  # PATCH or PUT /users/:id
  def update
    @user.update!(user_params)
    if @user.image.attached?
      @user.image.purge
    end
    @user.image.attach(params[:image])
    head :no_content
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    head :no_content
  end

  # GET /users/:id/portfolio
  def portfolio
    portfolio = Portfolio.new(@user.apps)
    json_response(portfolio)
  end 

  # GET /users/:id/skills
  def skills
    skills = SkillsList.new(@user.skills)
    json_response(skills)
  end 

  private

  def user_params
    # whitelist params
    params.permit(:user, :id, :name, :img, :image, :is_dev, :dev_bio, :dev_twitter, :dev_github, :dev_linkedin, :dev_portfolio)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
