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
        arraylist=adjacent(matrix)
        render json: { 
                :value => matrix,
                :arraylist => arraylist
            }.to_json
    end
    

    def checkWord
     parameters= params[:board]
     render json: { params: parameters }
  
    end

    def adjacent(board)
        arlist=[]
        # people = [["A", "B", "C","I"], ["D", "G", "B","L"], ["Y", "M", "P","K"], ["N", "E", "X","R"]]
        people=board
        list=""
        people.each_with_index do |row,indexrow|                      
            row.each_with_index do |row,indexcol|               
                nextrowindex=indexrow+1  
                nextcolindex=indexcol+1  
                if nextcolindex<4 
                    #for columns adjacent  
                    data=people[indexrow][indexcol]+people[indexrow][nextcolindex]
                    data=data.split('').sort.join
                    arlist.append(data)
                end                          
                if nextrowindex<4
                    #for rows adjacent 
                    data= people[indexrow][indexcol]+people[nextrowindex][indexcol]
                    data=data.split('').sort.join
                    arlist.append(data)
                end  
                if indexrow<3 && indexcol<3
                    #for right diagonals
                    data=people[indexrow][indexcol]+people[nextrowindex][nextcolindex]
                    data=data.split('').sort.join
                    arlist.append(data)
                end
                if indexrow<3 && indexcol>0
                    nextrow=indexrow+1
                    nextcol=indexcol-1
                    #for left diagonals
                    data=people[indexrow][indexcol]+people[nextrow][nextcol]
                    data=data.split('').sort.join
                    arlist.append(data)
                end

               x=arlist.sort_by(&:first)                                           
            end
        end
        return arlist
        # render json: {            
        #     :a0 => arlist
        # }.to_json
        
    end
end
