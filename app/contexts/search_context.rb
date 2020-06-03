
Dev_search_fields ||= ["name", "dev_bio"]
App_search_fields ||= ["name", "description"]

class SearchContext 

    def self.query (terms = [])
        # Because we haven't pre-processed the data into text indexes yet,
        # the most we can do is query on devs and apps in terms of 
        # regular expressions.

        matching_devs = Search.search_devs(terms)
        #matching_apps = Search.search_apps(terms)

        # To identify which terms matched, and HOW WELL, we will take the route of running the search
        # AGAIN in memory to determine how each matching item matched the terms
        ranked_devs = Rank.rank_devs(matching_devs, terms).sort { |a, b| 
            b["stats"]["score"] - a["stats"]["score"]
        }
        #ranked_apps = Rank.rank_apps(matching_apps, terms)

        # For now it looks like we only support dev search, so we just return the results for ranked devs
        ranked_devs

    end
end

class Search 

    def self.search_devs(terms, conds = nil)
        search_expressions = self.gen_search_expr(Dev_search_fields, terms)
        expr = if conds then User.where(conds) else User.none end
        search_expressions.each { |pair| 
            expr = expr.or(User.where(pair[0], pair[1]))
        }
        expr
    end

    def self.search_apps(terms, conds = nil)
        search_expressions = self.gen_search_expr(App_search_fields, terms)
        expr = if conds then User.where(conds) else App.none end
        search_expressions.each { |pair| 
            expr = expr.or(App.where(pair[0], pair[1]))
        }
        expr

    end

    def self.gen_search_expr(search_fields, terms) 
        array = search_fields.map { |field| 
            terms.map { |term| 
                ["#{field} LIKE ?", "%#{term}%"]
            }
        }
        array.flatten(1)
    end

end


class Rank 

    def self.rank_devs(devs, terms)
        matches = self.gen_matches(devs, Dev_search_fields, terms)
        ranking_stats = self.gen_ranking_stats(matches, terms.length)

        ranked_arr = []
        devs.each_with_index { |dev, index| 
            # For the sake of the frontend, Dev search results will be joined in memory with top 3 app matching apps for 
            # their specific apps
            apps = devs[index].apps
            top_ranked_apps = self.rank_apps(apps, terms).sort {|a, b|
                b["stats"]["score"] - a["stats"]["score"]
            } .take(3)

            top_ranked_apps.map {|app|
                with_rating = AppContext.find_by(id: app["data"]["id"])
                app["rating"] = with_rating["ratings"]
                app
            }

            ranked_arr.push({
                "stats" => ranking_stats[index],
                "data" => devs[index].attributes.extract!(*(["img", "id"].concat(Dev_search_fields))),
                "apps" => top_ranked_apps,
            })
        }


        ranked_arr
    end

    def self.rank_apps(apps, terms) 
        matches = self.gen_matches(apps, App_search_fields, terms)
        ranking_stats = self.gen_ranking_stats(matches, terms.length)

        ranked_arr = []
        apps.each_with_index { |app, index| 
            ranked_arr.push({
                "stats" => ranking_stats[index],
                "data" => apps[index].attributes.extract!(*(["img", "id"].concat(App_search_fields))),
            })
        }

        ranked_arr
    end

    # This function goes through all the matches and calculates proportion of terms matched
    def self.gen_ranking_stats(matches, term_count)
        percent_matches = (matches.map { |match|
            match_count = match.to_a.inject(0) { |memo, entry|
                if entry[1].length > 0 
                    memo + 1
                else 
                    memo
                end
            }

            { 
                "matches" => match,
                "score" => if term_count then (match_count.to_f / term_count) else 0 end
            }
        })
        percent_matches
    end

    def self.gen_matches(models, fields, terms)
        matches = models.map { |model| 
            term_matches = {}
            terms.each{ |term| 
                field_matches = {}

                fields.each { |field| 
                    data = /#{term}/i.match(model[field].to_s)
                    if data
                        field_matches[field] = {
                            "begin" => data.begin(0),
                            "end" => data.end(0)
                        }    
                    end
                } 
                term_matches[term] = field_matches
            }
            term_matches
        }
        matches
    end



end