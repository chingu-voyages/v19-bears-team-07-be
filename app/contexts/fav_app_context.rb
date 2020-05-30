# This class is responsible for fetching and organizing
# data about apps in a coherent Hash that can be sent to the frontend
SELECT = "apps.*, user_favorite_apps.user_id as follower_id, user_favorite_apps.app_id as favapp_id"
FavoriteJoin = -> (params) { "LEFT OUTER JOIN \"user_favorite_apps\" ON \"user_favorite_apps\".\"app_id\" = \"apps\".\"id\" AND " + 
                    "\"user_favorite_apps\".\"user_id\" = #{params[:current_user]["id"]}" }

class FavAppContext
    # Simple function that fetches all apps, and if the current user is logged in, attaches a 'is_favorite'
    # tag to the hash
    def self.all (params = {})
        if params[:current_user]
            apps = App.joins(FavoriteJoin.call(params)).select(SELECT)
            self.to_hashes(apps)
        else
            apps = App.all
            self.to_hashes(apps)
        end
    end

    def self.find_by (params = {}) 
        if params[:current_user]
            app = App.joins(FavoriteJoin.call(params)).select(SELECT).find_by(params.except(:current_user))
            self.to_hash(app)
        else
            app = App.find_by(params.except(:current_user))
            self.to_hash(app)
        end
    end

    def self.where (params = {})
        if params[:current_user]
            apps = App.joins(FavoriteJoin.call(params)).select(SELECT).where(params.except(:current_user))
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
        hash["is_favorite"] = hash["follower_id"] != nil
        hash
    end
end