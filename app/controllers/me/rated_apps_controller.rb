# This controller allows the user to view the ratings he's given,
# and to add/delete ratings (1 max)
class Me::RatedAppsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user

    # GET me/ratings
    def index 
        if @user 
            ratings = Rating.where(reviewer: @user)
            json_response(ratings)
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
                rating = Rating.find_by(reviewer: @user, reviewed_app: @app)
                score = rating_params[:score]
                if score
                    if rating
                        rating.score = score
                        rating.save!
                    else 
                        Rating.create!(reviewer: @user, reviewed_app: @app, score: score)
                    end
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
        params.permit(:id, :score)
    end

end