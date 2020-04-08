class Api::GameController < ApplicationController
    def index
        render json: { :games => [
            {
                :name => 'Boggle',
                :developer => 'Nitu Vaidya'
        }]
            }.to_json
    end 

    def getRandomChars
        matrix = Array.new(4) { Array.new(4) { Array('A'..'Z').sample } }
        random_string = Array('A'..'Z').sample(16).join
        render json: { 
                :value => matrix
            }.to_json
    end

end
