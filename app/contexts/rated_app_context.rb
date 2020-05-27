# This class is responsible for fetching and organizing
# rating data about apps in a coherent Hash that can be sent to the frontend
SELECT = "apps.*, ratings.user_id as reviewer_id, ratings.app_id as reviewed_app_id, ratings.score"
RatingsJoin = -> (params) { "LEFT OUTER JOIN \"ratings\" ON \"ratings\".\"app_id\" = \"apps\".\"id\" AND " + 
                    "\"ratings\".\"user_id\" = #{params[:current_user]["id"]}" }

class RatedAppContext
    # Simple function that fetches all apps, and if the current user is logged in, attaches a 'is_favorite'
    # tag to the hash
    def self.all (params = {})
        if params[:current_user]
            apps = App.joins(RatingsJoin.call(params)).select(SELECT)
            self.to_hashes(apps)
        else
            apps = App.all
            self.to_hashes(apps)
        end
    end

    def self.find_by (params = {}) 
        if params[:current_user]
            app = App.joins(RatingsJoin.call(params)).select(SELECT).find_by(params.except(:current_user))
            self.to_hash(app)
        else
            app = App.find_by(params.except(:current_user))
            self.to_hash(app)
        end
    end

    def self.where (params = {})
        if params[:current_user]
            apps = App.joins(RatingsJoin.call(params)).select(SELECT).where(params.except(:current_user))
            self.to_hashes(apps)
        else 
            apps = App.where(params.except(:current_user))
            self.to_hashes(apps)
        end
    end


    def self.to_hashes (apps)
        apps.map { |app| 
            self.to_hash(app)
        }
    end

    def self.to_hash(app)
        hash = app.attributes
        hash["score"] = if hash["score"] then hash["score"] else 0 end
        hash
    end
end 