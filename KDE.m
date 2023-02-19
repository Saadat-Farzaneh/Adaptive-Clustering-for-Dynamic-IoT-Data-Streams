% This function returns probability density estimate f that is calculated
% by ksdensity function and then plots it and save this plot on a folder
% for saving file that is special for each time.
function [f,xi,WM]=KDE(v,Title,OutputName,MainFolderPath,SaveFolderPath)
 
    [f,xi] = ksdensity(v);
     
    WM=WMean(xi,f);
     
    figure('visible','off');
    plot(xi,f);
     
    title(Title);
     
    cd(SaveFolderPath);
     
    print(OutputName,'-djpeg');
     
    close;
     
    cd(MainFolderPath);
     
end
    