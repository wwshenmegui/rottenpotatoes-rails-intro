class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G','PG','PG-13','R']
    end
    
    def self.find_by_ratings ratings
        @movies= Movie.uniq.where(["rating in (?)",ratings])
    end
end
