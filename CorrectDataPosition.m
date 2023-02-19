function X=CorrectDataPosition(X)
 
    while true
              
        D=pdist2(X,X);
        [row,col]=find(D==0);
        
        if numel(row)==size(X,1)
            break;
        end
        
        visited=false(size(row));
        
        for l=1:size(row)
            
            if ~visited(l)
                visited(l)=true;
            else
                continue
            end
            
            if row(l)~=col(l)
                
                X(row(l),:)=...
                    X(row(l),:)+1;
                X(col(l),:)=...
                    X(col(l),:)-1;
                
                visited(row==col(l)&col==row(l))=true;
            end
        end
        
    end
end
