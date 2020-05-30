class Me::FavoriteAppsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    # GET me/favorite_apps
    def index 
        if @user 
            apps = current_user.favorite_apps
            json_response(apps)
        else
            head :forbidden
        end
    end

    # PUT me/favorite_apps/:id
    def update
        @app = App.find(fav_params[:id])

        if !@app 
            head :not_found
        else
            if @user
                if UserFavoriteApp.where(follower: @user, favorite_app: @app).length == 0
                    @user.favorite_apps = @user.favorite_apps + [@app]
                end
                head :no_content
            else
                head :forbidden
            end
        end

    end

    # DELETE me/favorite_apps/:id
    def destroy
        @app = App.find(fav_params[:id])

        if !@app
            head :not_found
        else 
            if @user
                UserFavoriteApp.destroy_by(follower: @user, favorite_app: @app)
            end
            head :no_content
        end

    end


    def set_user 
        @user = current_user
    end

    def fav_params
        params.permit(:id)
    end

end