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
        render json: { 
                :value => matrix
            }.to_json
    end

    def getrandom
        charset = Array('A'..'Z') + Array('a'..'z') # to randomize data effectively
        result=charset.sample.upcase
        return result
    end
    
    def chr(char,adjacentvalues) 
        x=getrandom
        #make adjacent values unique and avoid cells from having value Q
        until !adjacentvalues.include?(x) and x!='Q'
            x= getrandom    
        end
        return x
    end



    def createBoard
        matrix = Array.new(4) { Array.new(4) { Array('A'..'Z').sample } }
        tvd=[]
        for i in 0..3
            for j in 0..3       
                # no adjacent cells should have same value    
                cellval=matrix[i][j]
                rs=adjacentlist(i,j,matrix,tvd)
                # make value of adjacent cells unique                
                rs=adjacentlist(i,j,matrix,tvd)
                #check that current cell value and adjacent cells are different
                rs.each do |key,val|
                    adlist=[]
                    val.map { |index,value|                     
                        adlist.push(value) 
                       }
                    matrix[i][j]=chr(cellval,adlist)
                end
                
            end
        end
        render json: { 
            :value => matrix
        }.to_json
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
    board=params[:board]
    arlist=params[:arlist]
    # word="YOUPEXKLPB"
    firstAdjacentslist=[]
    #  board = [["A", "B", "C","I"], ["D", "O", "B","L"], ["Y", "U", "P","K"], ["N", "E", "X","R"]]
    list=""
    traversed=[]
    i=0
    exists =false
    boardchars=""  

    #get index of first char in word
    board.each_with_index do |row,indexrow|                      
        row.each_with_index do |col,indexcol| 
            boardchars+=col
            if col==word[0,1]   
                position=[indexrow,indexcol]
                # traversed.append(position)  
                list = adjacentlist(indexrow,indexcol,board,traversed)
                firstAdjacentslist.append(list)              
            end          
        end
    end

    
    if firstAdjacentslist.length>0                          
         firstAdjacentslist.each do |item|           
            if !exists
                traversed=[] 
                result=checkloop(item,1,word,board,traversed,false)
                exists=result                
            else
                break
            end                           
        end        
    end   
        
    render json: {   
        :board => board,
        :a0 => firstAdjacentslist,  # if null, doesnt exist
        :traversed => traversed,
        :exists =>exists
    }.to_json
end

def checklist(char, item,board,traversed)  
    nextadjacentlist=[]        
            #add index of traversed cell
        item.map{|position,value|            
            if value.include?(char)  #check if adjacent cell contains next character              
                indexrow=position[0]
                indexcol=position[1]
                place=[indexrow,indexcol]   
                if traversed.include? (place) 
                    p "already traversed"                                          
                else                        
                #if contains, get cell position and adjacent list of that cell
                    nextadjlist=adjacentlist(indexrow,indexcol,board,traversed)  
                    nextadjacentlist.push(nextadjlist)
                end
            end
        }
        if nextadjacentlist.length>0
            return nextadjacentlist
        else
            return []
        end
end

    def checkloop(adjacentlist,wordindex,word,board,traversed,wordexists)
        if adjacentlist.length==0

        end
        nextadjacentlist=adjacentlist
        exists=false
        rslt={}
            i=wordindex
            char=word[i,1]
                if !exists
                    if nextadjacentlist.length>0
                        nextadjacentlist.each do |itemindex,itemval|
                                traversed.push(itemindex)
                                result=checklist(char,itemval,board,traversed)
                                if result.length>0
                                    i=i+1
                                    if i<word.length
                                        result.each do |itm|
                                            if !exists  
                                                rslt=checkloop(itm,i,word,board,traversed,false) 
                                                exists=rslt
                                                if exists
                                                    return exists
                                                end                                                
                                            else
                                                break                                  
                                            end
                                        end
                                    elsif i==word.length
                                        if result
                                            exists=true
                                            return exists
                                            break
                                        end
                                    end
                                else
                                    exists=false
                                    traversed=[] 
                                    
                                end
                        
                        end
                    end
                end
            
        return exists 
    end

end