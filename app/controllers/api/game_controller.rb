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
                p "word exists1 ", result
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
            p "adjlist",item
            # rst=clients.select{|key, hash| hash["key"] == char }
        item.map{|position,value|
            # p "position", position
            # p "value",value
            if value.include?(char)  #check if adjacent cell contains next character              
                indexrow=position[0]
                indexcol=position[1]
                place=[indexrow,indexcol]   
                p "traversed", traversed   
                if traversed.include? (place) 
                    p "already traversed"                                          
                else                        
                #  traversed.push(place)             
                #if contains, get cell position and adjacent list of that cell
                    nextadjlist=adjacentlist(indexrow,indexcol,board,traversed)  
                    nextadjacentlist.push(nextadjlist)
                end
            end
        }
        if nextadjacentlist.length>0
            p "checklistresult", nextadjacentlist
            return nextadjacentlist
        else
            return []
        end
end

    def checkloop(adjacentlist,wordindex,word,board,traversed,wordexists)
        
        nextadjacentlist=adjacentlist
        exists=false
        # exists=wordexists
        # if exists==true
        #     return exists
        # end
        rslt={}
            i=wordindex
            p i
            p "word",word
                char=word[i,1]
                p "char",char
                p "nextadjlist",nextadjacentlist
                if !exists
                    if nextadjacentlist.length>0
                        nextadjacentlist.each do |itemindex,itemval|
                                p "itemval",itemval
                                traversed.push(itemindex)
                                result=checklist(char,itemval,board,traversed)
                                p "result",result
                                if result.length>0
                                    i=i+1
                                    if i<word.length
                                        result.each do |itm|
                                            if !exists  
                                                rslt=checkloop(itm,i,word,board,traversed,false) 
                                                p "rslt",rslt
                                                exists=rslt
                                                if exists
                                                    return exists
                                                end                                                
                                            else
                                                break                                  
                                            end
                                        end
                                    elsif i==word.length
                                        p "ends here"
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
                # else
                #     exists=true
                end
            
        p "exists2", exists
        return exists 
    end

    def loopcheck(char,itemval,board,traversed)
        result=checklist(char,itemval,board,traversed)
                        p "result",result
                        if result
                            if result.length>0
                                p "has result"
                                i=i+1
                                if i<word.length
                                # exists=true
                                    result.each do |itm|
                                        if !exists  
                                            p "itm", itm              
                                            rslt=checkloop(itm,i,word,board,traversed)
                                            if rslt
                                                exists=true
                                                break
                                            else 
                                                exists = false
                                                traversed=[] 
                                            end
                                        end
                                        # if !rslt
                                        #      break 
                                        # end
                                    end
                                elsif i==word.length
                                    p "ends here"
                                    if result
                                        exists=true
                                    end
                                end
                            else
                                p "has no result"
                                exists=false
                            end
                        else
                            exists=false
                            traversed=[] 
                        end
    end

end