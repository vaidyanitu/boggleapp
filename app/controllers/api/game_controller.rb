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
        cs = [*'A'..'Z']
        returnString=Array.new(16) { cs.sample }.join
        render json: { 
                :value => returnString
            }.to_json
    end

end
