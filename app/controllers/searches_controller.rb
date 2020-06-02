=begin
This file defines a controller for handling search queries. Search
queries will be defined as a simple query parameter, called 'q', to
a GET request. Query terms will be separated by '+' characters.

Search will be performed over Apps and Dev profiles ONLY.

Currently the only supported search will be through OR queries on the dev
and app data.

Ranking will be done according to a simple percent match (number of terms matched)

=end

class SearchesController < ApplicationController

  # GET /search
  def index 
    search_params = params.permit(:q)
    search_string = if search_params[:q] then search_params[:q].to_s else "" end
    search_terms = search_string.split(' ')

    results = SearchContext.query(search_terms)

    json_response(results)
  end

end