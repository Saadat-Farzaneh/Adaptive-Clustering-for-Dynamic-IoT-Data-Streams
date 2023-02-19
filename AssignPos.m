%{
    This function reads report id from last column of data matrix and 
    search it in metadata file and when finds it, reads position related to 
    thhe reports id and according number of cors that exist in the row, find 
    some points where cars maybe there are on them.
%}

function [newdata1,newdata2]=AssignPos(data,metadata)
 
    [n,m]=size(data);
    
    newdata1=zeros(n,m+6);
    
    newdata2=zeros(sum(data(:,4)),m+2);
    
    counter=0;
    
    for i=1:n
        
        %creat newdata1 that inculeds column which there are in data and is added
        %4 column to it. The first four column are related to points positions and 
        %fifth column is distance between these two points and last column
        %represent disty of cars in each meter. 
        
        newdata1(i,1:6)=data(i,:);
        newdata1(i,7)=metadata(metadata(:,1)==data(i,3),3);
        newdata1(i,8)=metadata(metadata(:,1)==data(i,3),4);
        newdata1(i,9)=metadata(metadata(:,1)==data(i,3),5);
        newdata1(i,10)=metadata(metadata(:,1)==data(i,3),6);   
        newdata1(i,11)=sqrt((newdata1(i,9)-newdata1(i,7))^2+...
            (newdata1(i,10)-newdata1(i,8))^2);
        newdata1(i,12)=newdata1(i,4)/newdata1(i,11);
        
        % creat newdata2
        
        if data(i,4)==1
            counter=counter+1;
            newdata2(counter,1:m)=data(i,1:m);
            newdata2(counter,m+1)=(metadata(metadata(:,1)==data(i,3),3)+...
                metadata(metadata(:,1)==data(i,3),5))/2;
            newdata2(counter,m+2)=(metadata(metadata(:,1)==data(i,3),4)+...
                metadata(metadata(:,1)==data(i,3),6))/2;
        else
            k=data(i,4);
            for j=1:k
                counter=counter+1;
                newdata2(counter,1:m)=data(i,1:m);
                newdata2(counter,m+1)=metadata(metadata(:,1)==data(i,3),3)+...
                    j*(metadata(metadata(:,1)==data(i,3),5)-...
                    metadata(metadata(:,1)==data(i,3),3))/(k-1);
                newdata2(counter,m+2)=metadata(metadata(:,1)==data(i,3),4)+...
                    j*(metadata(metadata(:,1)==data(i,3),6)-...
                    metadata(metadata(:,1)==data(i,3),4))/(k-1);
            end
        end
    end
 
end
