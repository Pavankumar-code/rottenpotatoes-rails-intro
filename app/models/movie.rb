class Movie < ActiveRecord::Base
    def self.all_ratings
        self.all.select(:rating).distinct.pluck(:rating)
    end
end
