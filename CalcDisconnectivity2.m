function q=CalcDisconnectivity2(A)
 
    n=size(A,1);
    
    Connected=false(n,1);
    
    NodesDeg=sum(A,2);
    
    DisNodes=find(NodesDeg==0, 1);
    
    NumEdges=sum(NodesDeg)/2;
    
    if isempty(DisNodes)&& NumEdges>=(n-1)
        
        Neighbors=RegionQuery(1);
        
        if numel(Neighbors)>0
            
            Connected(1)=true;
            
            ExpandNeighbors(Neighbors);
            
        end
    end
    
    q=1-mean(Connected);
 
 
    function ExpandNeighbors(Neighbors)
        
        k = 1;
        while true
            j = Neighbors(k);
            
            if ~Connected(j)
                Connected(j)=true;
                Neighbors2=RegionQuery(j);
                Neighbors=[Neighbors Neighbors2];   %#ok   
            end
            
            k = k + 1;
            if k > numel(Neighbors)
                break;
            end
        end
    end
    
    function Neighbors=RegionQuery(i)
        Neighbors=find(A(i,:)==1);
    end
   
end
