clc;
clear;
%%
% Each date has a numerical equivalent that can be converted to date
% format. In this sction, the program creats a vector of euivalent amount
% of dates between March,1th,2014 and March,31th,2014.
date_values=41699:41729;
%%
% In this section the program creates a cell of heards of excel file that
% is created at the end of each for loop.
headers = {'DATESTAMP','TIMESTAMP','REPORT_ID','vehicleCount',...
    'avgMeasuredTime','avgSpeed'};
%%
% In currect folder there are 22 excel files that each of them includes
% measured data and some other data related to some of measurement points.
% in this section the porgram frist creats a new folder by the name of
% March_2014_days that data related to each day is saved in it. 
% Then the program read each of these 22 excel files and extract data about
% each day from these files, and at the end exports a excel file that
% inclueds the data. 
mkdir March_2014_days
for i=1:31
    
    values=nan((449*12*24),6);
    
    first=1;
    
    for j=1:22
        
        file_name=strcat('citypulse_traffic_',num2str(j),'.xlsx');
        
        data=xlsread(file_name);
        
        data=data(data(:,1)==date_values(i),:);
        
        last=first+size(data,1)-1;
        
        values(first:last,:)=data;
        
        first=last+1;
        clear data
        
    end
    
    values=num2cell(values);
    output_file_name=strcat(num2str(i),'.xlsx');
    cd March_2014_days
    xlswrite(output_file_name,[headers; values]);
    
    cd ..
    clear values
    
    
end
