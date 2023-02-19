clc
clear
close all
 
% 
mkdir times
headers = {'DATESTAMP','TIMESTAMP','REPORT_ID','vehicleCount',...
    'avgMeasuredTime','avgSpeed'};
for i=1:31
    data=xlsread(strcat(num2str(i),'.xlsx'));
    time_vector=unique(data(:,2));
    
    for j=1:size(time_vector,1)
        values=data(data(:,2)==time_vector(j),:);
        
        cd ..
        cd ..
        
        output_file_name=strcat(num2date(values(1,1),2),...
            num2HrMin(values(1,2),2),'.xlsx');
         
        values=num2cell(values);
        
        cd March_2014_dataset\days\times 
        xlswrite(output_file_name,[headers; values]);
        
        clear values output_file_name 
        cd .. 
    end 
        
        
end
