# This controller allows the user to view the ratings he's given,
# and to add/delete ratings (1 max)
class Me::RatingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    # GET me/ratings
    def index 
        if @user 
            apps = current_user.reviewed_apps
            json_response(apps)
        else
            head :forbidden
        end
    end

    # PUT me/ratings/:id
    def update
        @app = App.find(rating_params[:id])

        if !@app 
            head :not_found
        else
            if @user
                if Rating.where(reviewer: @user, reviewed_app: @app).length == 0
                    @user.reviewed_apps = @user.reviewed_apps + [@app]
                end
                head :no_content
            else
                head :forbidden
            end
        end

    end

    # DELETE me/ratings/:id
    def destroy
        @app = App.find(rating_params[:id])

        if !@app
            head :not_found
        else 
            if @user
                Rating.destroy_by(reviewer: @user, reviewed_app: @app)
            end
            head :no_content
        end

    end


    def set_user 
        @user = current_user
    end

    def rating_params
        params.permit(:id)
    end

end