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
        
        # random_string = Array('A'..'Z').sample(16).join
        matrix = Array.new(4) { Array.new(4) { Array('A'..'Z').sample } }
        arraylist=dfs(matrix)
        render json: { 
                :value => matrix,
                :arraylist => arraylist
            }.to_json
    end
    

    def dfs(board)
        firstAdjacentslist=[]
        # board = [["A", "B", "C","I"], ["D", "G", "B","L"], ["Y", "M", "P","K"], ["N", "E", "X","R"]]
        people=board
        list=""
        people.each_with_index do |row,indexrow|                      
            row.each_with_index do |row,indexcol|  
                arlist=[]             
                nextrowindex=indexrow+1  
                nextcolindex=indexcol+1  
                if indexrow>0  #up traversal
                    #for row above 
                    data=people[indexrow][indexcol]+people[indexrow-1][indexcol]
                    arlist.append(data)
                    #for left diagonal above
                    if indexcol<3
                    data=people[indexrow][indexcol]+people[indexrow-1][indexcol+1]
                    # data=data.split('').sort.join
                    arlist.append(data)
                    end
                    
                    if indexcol>0
                        #for right diagonal above
                        data=people[indexrow][indexcol]+people[indexrow-1][indexcol-1]
                        # data=data.split('').sort.join
                        arlist.append(data)
                        
                    end
                end
                if indexcol>0 #left traversal
                        #for col left 
                        data=people[indexrow][indexcol]+people[indexrow][indexcol-1]
                        arlist.append(data)                    
                end

                if nextcolindex<4 
                    #for columns right  
                    data=people[indexrow][indexcol]+people[indexrow][nextcolindex]
                    # data=data.split('').sort.join
                    arlist.append(data)
                end                          
                if nextrowindex<4
                    #for row right 
                    data= people[indexrow][indexcol]+people[nextrowindex][indexcol]
                    # data=data.split('').sort.join
                    arlist.append(data)
                end  
                if indexrow<3 && indexcol<3
                    #for right diagonals below
                    data=people[indexrow][indexcol]+people[nextrowindex][nextcolindex]
                    # data=data.split('').sort.join
                    arlist.append(data)
                end
                if indexrow<3 && indexcol>0
                    nextrow=indexrow+1
                    nextcol=indexcol-1
                    #for left diagonals below
                    data=people[indexrow][indexcol]+people[nextrow][nextcol]
                    # data=data.split('').sort.join
                    arlist.append(data)
                end
                firstAdjacentslist.append(arlist)
            end
        end
        return firstAdjacentslist
        # render json: {   
        #     :board => board,         
        #     :a0 => firstAdjacentslist
        # }.to_json
        
    end

def adjacentlist(indexrow,indexcol,people,traversed)
    arlist={}      
    nextrowindex=indexrow+1
    nextcolindex=indexcol+1 
    prevrowindex=indexrow-1  
    prevcolindex=indexcol-1 
    ind=[indexrow,indexcol] 
    arr={}
                    if indexrow>0  #up traversal
                        #for row above 
                        data=addtolist(prevrowindex,indexcol,traversed,arr,*people)                        
                        #for left diagonal above
                        if indexcol>0                           
                            data=addtolist(prevrowindex,prevcolindex,traversed,arr,*people)  
                        end                        
                        if indexcol<3
                            #for right diagonal above
                            data=addtolist(prevrowindex,nextcolindex,traversed,arr,*people)                     
                        end
                    end
                    if indexcol>0  #left traversal
                            data=addtolist(indexrow,prevcolindex,traversed,arr,*people)           
                    end

                    if indexcol<3 
                        #for columns right  
                        data=addtolist(indexrow,nextcolindex,traversed,arr,*people) 
                    end                          
                    if indexrow<3
                        #for row below 
                        data=addtolist(nextrowindex,indexcol,traversed,arr,*people)
                    end  
                    if indexrow<3 && indexcol<3
                        #for right diagonals below
                        data=addtolist(nextrowindex,nextcolindex,traversed,arr,*people)  
                    end
                    if indexrow<3 && indexcol>0                     
                        #for left diagonals below                         
                        data=addtolist(nextrowindex,prevcolindex,traversed,arr,*people) 
                    end
                    
                     arlist[ind] =arr
    return arlist
end

def addtolist(row,col,traversed,arr,*people)
    position=[row,col]
    if !traversed.include?(position)
     dt=people[row][col]
     arr[position]=dt
    end
end


def checkWord
    word= params[:word]      
    p word      
    board=params[:board]
    arlist=params[:arlist]
    # word="YOUPEXKLPB"
    samechar=[]
    firstAdjacentslist=[]
    #  board = [["A", "B", "C","I"], ["D", "O", "B","L"], ["Y", "U", "P","K"], ["N", "E", "X","R"]]
    people=board
    list=""
    traversed=[]
    i=0
    exists =false
    boardchars=""  

    #get index of first char in word
    people.each_with_index do |row,indexrow|                      
        row.each_with_index do |col,indexcol| 
            boardchars+=col
            if col==word[0,1]   
                position=[indexrow,indexcol]
                # traversed.append(position)  
                list = adjacentlist(indexrow,indexcol,people,traversed)
                firstAdjacentslist.append(list)              
            end          
        end
    end

    
    if firstAdjacentslist.length>0                          
         firstAdjacentslist.each do |item| 
            if !exists
                adjl=item      
                for i in 1...word.length  
                    p i 
                    #iterate through each character in word           
                    char= word[i].chr 
                    p char
                    if !boardchars.include?(char)
                        exists=false 
                        break                   
                    else
                        if adjl.length>0                 
                            result=checklist(char,adjl,people,traversed) 
                            if result
                                adjl=result
                                exists=true
                                #   next
                            else                       
                                exists=false 
                                break                                            
                            end 
                        end  
                    end
                end  
            end                               
        end        
    end   
        
    render json: {   
        :board => people,
        :a0 => firstAdjacentslist,  # if null, doesnt exist
        :traversed => traversed,
        :wordexists =>exists
    }.to_json
end

def checklist(char, item,people,traversed)
    item.each do |index,adjlist|
        traversed.push(index)     #add index of traversed cell
        adjlist.each do |position,value|
            if value.include?(char) #check if adjacent cell contains next character
                indexrow=position[0]
                indexcol=position[1]
                p(indexrow+indexcol)
                #if contains, get cell position and adjacent list of that cell
                nextadjlist=adjacentlist(indexrow,indexcol,people,traversed)  
                p nextadjlist
                return nextadjlist
            else
                #if doesn't contain, continue loop
                next
            end
        end
        return
    end
end

    

end