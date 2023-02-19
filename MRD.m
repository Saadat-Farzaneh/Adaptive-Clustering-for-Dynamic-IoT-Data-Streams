%{
    The function calculates The Mutual Reachability Distance Graph (MRD)
    that is a complete graph with objects in the cluster C as vertices and
    the mutual reachability distance between the respective pair of objects
    as the weight of each edge.
    The inputs of this function are: D and a_pts_coredist
    D is the matrix of pairwise distances between object in the cluster C,
    and a_pts_coredist is a vector that includes all-points-core-distance
    of all point in the cluster C. 
%}
function MRD=MRD(D,a_pts_coredist)
    % Initialization 
    
    MRD=zeros(size(D));
        for i=1:size(MRD,1)
            for j=1+1:size(MRD,1)
                MRD(i,j)=max([a_pts_coredist(i),a_pts_coredist(j),D(i,j)]);
                MRD(j,i)=MRD(i,j);    
            end
        end
end
