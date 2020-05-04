class Movie < ActiveRecord::Base
    #attr_accessor :title, :rating, :description, :release_date
    def self.all_ratings
        a = Array.new
        self.select("rating").uniq.each {|x| a.push(x.rating)}
        a.sort.uniq
    
       ['G', 'PG', 'PG-13', 'R']
    end
end
