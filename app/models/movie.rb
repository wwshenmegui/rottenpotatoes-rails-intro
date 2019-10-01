class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G','PG','PG-13','R']
    end
    
    def self.find ratings
        @movies= Movie.where(["rating in (?)",ratings])
    end
end
