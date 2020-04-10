class Boardgame

    def initialize
        board=getRandomChars()
        adjacentlist=adjacent()
    end

    def getdata
        p adjacentlist
        render json: { 
            :board => board,
            :value => adjacentlist
        }.to_json
    end

    def getRandomChars
        matrix = Array.new(4) { Array.new(4) { Array('A'..'Z').sample } }
        random_string = Array('A'..'Z').sample(16).join
        # render json: { 
        #         :value => matrix
        #     }.to_json
    end

   

    def adjacent
        arlist=[]
        people = [["A", "B", "C","I"], ["D", "G", "B","L"], ["Y", "M", "P","K"], ["N", "E", "X","R"]]

        
        people.each_with_index do |row,indexrow|                      
            row.each_with_index do |row,indexcol|               
                nextrowindex=indexrow+1  
                nextcolindex=indexcol+1  
                if nextcolindex<4 
                    arrlen=arlist.length()
                    #for columns adjacent  
                    arlist[arrlen]=[people[indexrow][indexcol],people[indexrow][nextcolindex]]
                end                          
                if nextrowindex<4
                    p people[indexrow][indexcol]
                    puts people[nextrowindex][indexcol]
                    arrlen=arlist.length()
                    #for rows adjacent  
                    arlist[arrlen]=[people[indexrow][indexcol],people[nextrowindex][indexcol]]
                end  
                if indexrow<3 && indexcol<3
                    arrlen=arlist.length()
                    #for right diagonals
                    arlist[arrlen]=[people[indexrow][indexcol],people[nextrowindex][nextcolindex]]
                end
                if indexrow<3 && indexcol>0
                    arrlen=arlist.length()
                    nextrow=indexrow+1
                    nextcol=indexcol-1
                    #for left diagonals
                    arlist[arrlen]=[people[indexrow][indexcol],people[nextrow][nextcol]]
                end

               x=arlist.sort_by(&:first)
               p x
                                                  
            end
        end
      return arlist
    end
end