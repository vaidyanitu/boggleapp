class HomeController < ApplicationController
    def index
        
    end
    def adjacent
        people = [["Bruce", "Wayne", "Batman"], ["Selina", "Kyle", "Catwoman"], ["Barbara", "Gordon", "Oracle"], ["Terry", "McGinnis", "Batman Beyond"]]

        people.each { |character| puts "#{character [0]}, a.k.a   #{character [1]} #{character [2]}" }
        
    end

end
