class Api::WordsController < ApplicationController
    def validwords
        # letters="BCDAEQZYROTQJIBV"
        letters= params[:boardchars]
        word=params[:searchword]
        # data=@letters.join(" ")
        url="https://codebox-boggle-v1.p.rapidapi.com/"+letters
        p url
        response = Unirest.get url,
        headers:{
          "X-RapidAPI-Host" => "codebox-boggle-v1.p.rapidapi.com",
          "X-RapidAPI-Key" => "d3aab2b19dmsh20dd7349214dd6dp13daa0jsn6bcb440d9f85"
        }
        
        render json: { 
            :value => response
                }.to_json
    end
end
