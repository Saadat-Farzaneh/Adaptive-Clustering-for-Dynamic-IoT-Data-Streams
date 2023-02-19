%{  
    Copyright (c) 2015, Yarpiz (www.yarpiz.com)
    All rights reserved. Please read the "license.txt" for license terms.

    Project Code: YPML110
    Project Title: Implementation of DBSCAN Clustering in MATLAB
    Publisher: Yarpiz (www.yarpiz.com)

    Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)

    Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%}
 
function PlotClusteringResult(X, IDX)
 
    k=max(IDX);
 
    Colors=hsv(k);
 
    for i=0:k
        Xi=X(IDX==i,:);
        if i~=0
            Style = 'x';
            MarkerSize = 8;
            Color = Colors(i,:);
        else
            Style = 'o';
            MarkerSize = 6;
            Color = [0 0 0];
        end
        if ~isempty(Xi)
            plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',MarkerSize,'Color',Color);
        end
        hold on;
    end
    hold off;
    axis equal;
    grid on;
 
end
