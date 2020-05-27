
class RatingsController < ApplicationController


  # GET /apps
  def index
    @ratings = Rating.all
    json_response(@ratings)
  end

end
