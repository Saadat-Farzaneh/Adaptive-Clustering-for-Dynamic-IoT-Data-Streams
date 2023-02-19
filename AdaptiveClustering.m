clc;
clear ;
close all;
 
%{
 pc=parcluster('local');
 
 pc.NumWorkers=4;
 
 parpool(pc,4); % start of Parallel Computing
%}

%{
 Because the program changes folder during running, It's needed to know  
 paths of different folders that the program go into them. In this section 
 the program  fist make a folder to save all outputs. Then it save paths 
 of main folder and outputs folder in a structure called 'paths'. For each 
 time, in the folder 'Outputs', in the next sections, a new folder is 
 creatd that all outputs related to the time save in it.
%}

OutputsFolderName = 'Outputs_NonAdaptive';
 
mkdir(OutputsFolderName);
 
paths.MainFolder=pwd;
paths.OutputsFolder=strcat(paths.MainFolder,'\',OutputsFolderName);
paths.xlsxfiles=strcat(paths.MainFolder,'\March_2014_dataset\days\times');
 
 
%%
% The program imports metadata file that includes informaton related to
% measurment points. 
metadata=xlsread('trafficMetaData.xlsx');
 
% In the metadata file locations are according Lat-long system and we need
% utm system. Below function convert lat-long to utm.
metadata(:,3:4)=ll2utm(metadata(:,3:4));
metadata(:,5:6)=ll2utm(metadata(:,5:6));
 
%%
% In this section the program creats a cell array of empty matrices that
% will contain general result for each time and each date. 
 
 
% The cell array save as a excel file at the end of this program.In the next 
% line header of this file are defind. 
 
headers={'DATESTAMP','TIMESTAMP','MinPts(NonAdaptive)',...
    'Epsilon(NonAdaptive)','DBCV (NonAdaptive)'};
%%
% In this section the program go into the folder which icludes excel files 
% that must be read. Then it reads information about all these excel files
% (xlsx files). we use file name to call each file. Names of files are in the
% field 'name' defined below. 
 
cd(paths.xlsxfiles);
 
FilesInfo=dir('*.xlsx');
 
%% 
% In the for loop that comes below, the program reads every xlsx files in
% each loop. Each of these files includes data that are measured and
% gathered at a certain time. The program in each loop uses these data for
% clustering. 
 
 for i=1:length(FilesInfo)

    GeneralResults=nan(1,5);
     
    cd(paths.xlsxfiles);
    data=xlsread(FilesInfo(i).name);
    
    % Changing directory 
    cd(paths.MainFolder)
    
    % We need a special folder to save all outputs that are related to the
    % date and the time which come in the first and second columne of data
    % matrix. 
    
    SaveFolderName=strcat(num2date(data(1,1),2),num2HrMin(data(1,2),2));
    mkdir(OutputsFolderName,SaveFolderName);
    paths.SaveFolder=strcat(paths.OutputsFolder,'\',SaveFolderName);
    
    % Fourth field of data is related to number of cars that there are in a 
    % specific area. The program removed all rows of data matrix that the
    % numbers in forth field of them are zero. 
    
    data(data(:,4)==0,:)=[];
    
    if isempty(data)
        continue
    end
    
    % In next lines, the program creats a structure called AllData that  
    % has some fields. Each fields contains some data that are related to 
    % related to a certain date and time. At the end of loop the structure
    % is saved by its date and time. 
       
    AllData.date=num2date(data(1,1));
    AllData.time=num2HrMin(data(1,2));
    
    % These data are measured between some pair point. Each pair point has a
    % report-id that there are some data related to this report-id in
    % Metadata file, especially two point that place at two end of this pair
    % point.  
    % In this section the program according these points and number of cars
    % that there are in 4th column of data file, creat some points equal by
    % the numbers of car and between these two point. 
    
    [AllData.newdata.unextended,AllData.newdata.extended]=...
        AssignPos(data,metadata);
    
    if isempty(AllData.newdata.extended)
        continue
    end
    
    It's possible that some positions of cars are equail and we know that
    %{
        two cars can't be exact in a same position. For this situations the
        program makes a small change in car positions for the cars that have
        same position.
    %}
          
    AllData.newdata.extended(:,7:8)=...
        CorrectDataPosition(AllData.newdata.extended(:,7:8));
   
    
    % define MinPts
    AllData.clustering.MinPts=7;
     
    %{
        In this porgram we compute epsilon by two methode. In first method we 
        use distance matrix. We sort each column of distance matrix. and then
        we select column by number MinPts of this sorted matrix. Values in
        this column are used to compute epsilon in this method. We estimate a
        probability density function of these value and then calculate
        expectation value as a wighted mean of these vlues, and we choose
        this wighted mean as our epsilon in the first method. 
        in the other method we use density of cars in different points of
        city. We use expection value of these densities and calculate epsilon
        by this equation: Epsilon= MinPts/weighted mean of density of cars.
        KDE of Epsilons which are possible according selected MinPts 
    %}
         
    % Defining Epsilon by using of distance matrix
    AllData.clustering.Eps=531;
    
    %%  
    % In this section, clustering process is done. We cluster data by both
    % of computed epsilon.
    
    % clustering by the epsilon that is coomputed by distance matrix.
    [AllData.clustering.IDX,...
        AllData.clustering.DBCV,~,~]=...
        DBSCAN(AllData.newdata.extended(:,7:8),...
        AllData.clustering.Eps,...
        AllData.clustering.MinPts,2);
     
    Title=strcat('Clustering  MinPts(NonAdaptive):',num2str(AllData.clustering.MinPts),...
        ' Eps(NonAdaptive):',...
        num2str(AllData.clustering.Eps),' Date:',...
        AllData.date{1,2},' Time:',AllData.time{1,2});
    OutputName=strcat(num2date(data(1,1),2),num2HrMin(data(1,2),2),...
        '_Clustering_NonAdaptive');
    
    Fig{1} = figure('visible','off');
    PlotClusterinResult(AllData.newdata.extended(:,7:8), ...
        AllData.clustering.IDX);
    
    cd(paths.SaveFolder);
    
    title(Title);
    print(OutputName,'-djpeg');
    
    clear OutputName Title
    
    close;  
    
    %% Save information 
    GeneralResults(i,:)=[data(1,1),data(1,2),...
        AllData.AveSpeed.KDE.WMean,AllData.CarsDens.KDE.WMean,...
        sum(data(:,4)),AllData.NumCars.KDE.WMean,...
        AllData.clustering.MinPts,...
        AllData.clustering.BasedonDistance.Eps1,...
        AllData.clustering.BasedonDistance.DBCV1,...
        AllData.clustering.BasedonCarsDen.Eps2,...
        AllData.clustering.BasedonDistance.DBCV2,...
        AllData.clustering.BasedonCarsDen.Eps3,...
        AllData.clustering.BasedonDistance.DBCV3,...
        AllData.clustering.BasedonCarsDen.Eps1,...
        AllData.clustering.BasedonCarsDen.DBCV1,...
        AllData.clustering.BasedonCarsDen.Eps2,...
        AllData.clustering.BasedonCarsDen.DBCV2,...
        AllData.clustering.BasedonCarsDen.Eps3,...
        AllData.clustering.BasedonCarsDen.DBCV3];
    
    cd(paths.MainFolder);
    
    FileName=strcat(num2date(data(1,1),2),num2HrMin(data(1,2),2),'.mat');
    
    cd(paths.SaveFolder);
    
%     save(FileName,'AllData');
    
    cd(paths.MainFolder)
    
    clear FileName Title OutputName AllData data
    
end  
 
% At the end, the program saves GeneralResults Matrix as a excel file. 
 
cd(paths.OutputsFolder);
 
GeneralResults=num2cell(GeneralResults(~isnan(GeneralResults(:,1)),:));
 
xlswrite('GeneralResults_Adaptive.xlsx',[headers;GeneralResults]);
