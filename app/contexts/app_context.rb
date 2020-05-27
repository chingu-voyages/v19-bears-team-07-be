# This class is responsible for fetching and organizing
# data about apps in a coherent Hash that can be sent to the frontend
SELECT_FAVS = " user_favorite_apps.user_id as follower_id, user_favorite_apps.app_id as favapp_id"
SELECT_RATINGS = " ratings.user_id as reviewer_id, ratings.app_id as reviewed_app_id, ratings.score"
SELECT = " apps.*, #{SELECT_FAVS}, #{SELECT_RATINGS}"

JoinFavorite = -> (params) {
    " LEFT OUTER JOIN \"user_favorite_apps\" ON \"user_favorite_apps\".\"app_id\" = \"apps\".\"id\" AND " + 
            "\"user_favorite_apps\".\"user_id\" = #{params[:current_user]["id"]} "
}
JoinRating = -> (params) {
    " LEFT OUTER JOIN \"ratings\" ON \"ratings\".\"app_id\" = \"apps\".\"id\" AND " + 
            "\"ratings\".\"user_id\" = #{params[:current_user]["id"]} " 
}
Join = -> (params) { 
    "#{JoinFavorite.call(params)} #{JoinRating.call(params)}"
}


class AppContext
    # Simple function that fetches all apps, and if the current user is logged in, attaches a 'is_favorite'
    # tag to the hash
    def self.all (params = {})
        if params[:current_user]
            apps = App.joins(Join.call(params)).select(SELECT)
            apps = self.to_hashes(apps)
        else
            apps = App.all
            apps = self.to_hashes(apps)
        end
        rating_stats = self.rating_stats_where
        self.with_ratings(apps, rating_stats)
    end

    def self.find_by (params = {}) 
        if params[:current_user]
            app = App.joins(Join.call(params)).select(SELECT).find_by(params.except(:current_user))
            app = self.to_hash(app)
        else
            app = App.find_by(params.except(:current_user))
            app = self.to_hash(app)
        end

        rating_stats = self.rating_stats_where(params.except(:current_user))
        self.with_rating(app, rating_stats)
    end

    def self.where (params = {})
        if params[:current_user]
            apps = App.joins(Join.call(params)).select(SELECT).where(params.except(:current_user))
            apps = self.to_hashes(apps)
        else 
            apps = App.where(params.except(:current_user))
            apps = self.to_hashes(apps)
        end

        rating_stats = self.rating_stats_where(params.except(:current_user))
        self.with_ratings(apps, rating_stats)
    end


    def self.to_hashes (apps)
        apps.map { |app| 
            self.to_hash(app)
        }
    end

    def self.to_hash(app)
        hash = app.attributes
        hash["is_favorite"] = hash["follower_id"] != nil
        hash["score"] = if hash["score"] then hash["score"] else 0 end
        hash
    end

    # Calculates rating stats for the specified group of apps
    def self.rating_stats_where(params = {})
        rating_stats = Rating.group(:app_id, :score).select("app_id, score, COUNT(*) as count").where(params).map {|rating|
            rating.attributes
        }
        aggregated_stats = { }
        rating_stats.each { |stat| 
            app_id = stat["app_id"]
            score = stat["score"]
            count = stat["count"]
            if aggregated_stats[ app_id ]
                # Update if we've seen this app before
                aggregated_stats[ app_id ][score] = count
            else 
                # Create stats object for this app if it's new
                aggregated_stats[ app_id ] = Hash.new
                aggregated_stats[ app_id ] [score] = count
            end
        }
        aggregated_stats
    end

    def self.with_ratings(apps, rating_stats)
        apps.map { | app | 
            self.with_rating(app, rating_stats)
        }
    end

    def self.with_rating(app, rating_stats)
        app["ratings"] = self.empty_ratings
        app_ratings = rating_stats[app["id"]]

        if app_ratings
            app_ratings.each { |score, count| 
                app["ratings"][score] = count
            }
        end
        app
    end

    private 

    def self.empty_ratings 
        {   1 => 0,  
            2 => 0, 
            3 => 0, 
            4 => 0, 
            5 => 0
        }
        
    end
end