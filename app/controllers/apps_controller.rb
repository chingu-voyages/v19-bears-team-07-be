class AppsController < ApplicationController
  before_action :set_app, only: [:show, :update, :destroy]


  # GET /apps
  def index
    category = Category.find_by(id: params[:category])
    if category
      @apps = AppContext.all(current_user: current_user, category: category)
    else
      @apps = AppContext.all(current_user: current_user)
    end
    json_response(@apps)
  end

  # GET /app/:id
  def show
    app = AppContext.find_by(current_user: current_user, id: @app)
    json_response(app)
  end

  # POST /apps
  def create
    @app = App.create(app_params)
    app = AppContext.find_by(current_user: current_user, id: @app)
    json_response(app, :created)
  end

  # PUT /apps/:id
  def update
    @app.update!(app_params)
    app = AppContext.find_by(current_user: current_user, id: @app)
    json_response(app)
  end

  # DELETE /apps/:id
  def destroy
    @app.destroy
    head :no_content
  end

  private

  def app_params
    # whitelist params
    params.permit(:name, :description, :img, :app_url, :github_url, :user_id)
  end

  def set_app
    @app = App.find(params[:id])
  end
end
