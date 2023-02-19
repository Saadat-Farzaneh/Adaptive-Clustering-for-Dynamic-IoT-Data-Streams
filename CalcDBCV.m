%{
    The function calculates the DBCV score of a clustering solution that
    clusters a set of data points by a density-based clustering approach.
    The inputs of this function are: X, IDX and d
    X is a set of data points. It is a matrix with two columns and n rows
    that n is the number of data objects. In our works data objects are some
    cartesian positions.
    IDX is a vector that includes the indexes of objects that are achieved
    by a density-based clustering approach. In this vector data objects that
    are known as noises, are determined by zero. 
    d is d dimension of space that in our work it is 2, but it can be more
    than 2 in the other problems. 
    The function is written based on the definition of DBCV in the following
    reference:
    D. Moulavi, P. A. Jaskowiak, R. J. Campello, A. Zimek, and J. Sander,
    “Density-based clustering validation,” presented at the Proceedings
    of the 2014 SIAM International Conference on Data Mining, 2014,
    pp. 839–847.
%}
function [DBCV,Cluster]=CalcDBCV(X,IDX,d)
    % First, we sort IDX and X based on sorted IDX.
    A=sortrows([IDX X]);
    IDX=A(:,1);
    X=A(:,2:3);
     
    % The following vector includes all number that are assigned to the
    % clusters
    IDXuni=unique(IDX);
     
    nCla=numel(IDXuni)-numel(find(IDXuni==0)); % number of clusters
    nDataPoints=size(X,1); % number of data points (data objects)
     
    switch nCla
        %{
            If the clustering approach can't cluster data point and knows all of
            them as noise or creates only one cluster and determines the other
            data points as noise, DBCV can't be calculated. In these situations,
            we assign zero to DBCV that it means it can't say how clustering
            olution is.
        %} 
        case 0 || 1
            DBCV=0;
            Cluster=NaN;
            
        otherwise
            % In this state, first, we define a structure to save data and 
            % results.
            empty_individual.X=[];
            empty_individual.nDataPoints=[];
            empty_individual.a_pts_coredist=[];
            empty_individual.MRD=[];
            empty_individual.MST_MRD=[];
            empty_individual.DSC=[];
            empty_individual.NodePoints=[];
            empty_individual.minDSPC=[];
            empty_individual.Vc=[];
            
            Cluster=repmat(empty_individual,nCla,1);
            
            % for each cluster the function has to calculate 
            for i=1:nCla
                
                % The data belonging to the ith cluster are separated.
                Cluster(i).X=X(IDX==i,:);
                % Number of data points (data objects) in the ith cluster
                Cluster(i).nDataPoints=size(Cluster(i).X,1);
                % The matrix of the perwise distance between the data points in  
                % the ith cluster is calculated. 
                Di=pdist2(Cluster(i).X,Cluster(i).X);
                
                % all-points-core-distance of all the data points (data objects)
                % in the ith cluster are calculated by a_pts_coredist fuction. 
                Cluster(i).a_pts_coredist=a_pts_coredist(Di,d);
                
                % The Mutual Reachability Distance Graph (MRD)of the ith
                % cluster is calculated by the MRD function. 
                Cluster(i).MRD=MRD(Di,Cluster(i).a_pts_coredist);
                
                % The Minimum Spanning Tree (MST) of the MRD graph of the ith 
                % cluster is calculated by the CalcMSTbyGA function. 
                Cluster(i).MST_MRD=CalcMSTbyGA(Cluster(i).MRD);
                
                %{
                    In the following line the Density Sparseness of the Cluster (
                    DSC) that is defined as the maximum edge weight of the
                    internal edges in the MST of the cluster, is calculated.
                %} 

                Cluster(i).DSC=max(Cluster(i).MST_MRD(:));
                %{
                    To calculate density sepration, the function needs to know
                    about set of internal edges in the MST of each cluster that
                    are all edges in the MST except those with one ending vertex
                    of degree one. The following lines find these internal object
                    and their all-points-core-distance. To find them, the
                    function uses the matrix of MST_MRD that is calculated in the
                    previous lines. In this matrix, each row corresponds to one 
                    of the objects. The function converts the matrix of MST_MRD
                    into an array of logical values that any nonzero element of 
                    MST_MRD is converted to logical 1 and zeros are converted to
                    logical 0. Then the function finds each row that more than 
                    one elements of it are 1. It means that it finds the rows 
                    that sum of their elements are more than 1. This rows 
                    correspond to the internal object of the cluster.
                %} 

                Cluster(i).InternalNodePoints=...
                    Cluster(i).X(sum(logical(Cluster(i).MST_MRD),2)>1,:);
            end
            
            % The function calculates Denstiy Separation with a function called
            % DensitySeparation.  
            
            Cluster=DensitySeparation(Cluster,d);
            
            % Initially, the function assigns zero to DBCV, and then updates
            % it.
            DBCV=0;
            
            for z=1:nCla
                Cluster(z).Vc=(Cluster(z).minDSPC-Cluster(z).DSC)/...
                    max(Cluster(z).minDSPC,Cluster(z).DSC);
                
                DBCV=DBCV+Cluster(z).nDataPoints*Cluster(z).Vc;
            end
            
            DBCV=DBCV/nDataPoints;
    end
     
     
    end
    