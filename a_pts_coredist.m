%{
    In this function we want to calculate the all-points-core-distance 
    (inverse of the density) of an object o, belonging to cluster Ci 
    w.r.t all other n-1(n is number of objects in cluster Ci) objects in Ci.
    The function returns all-points-core-distnace of all object in the
    cluster Ci in a vector.
    In this function D is an n*n matrix of pairwise distances between objects
    in the cluster Ci, and d is d dimension of space. 
%}
function a_pts_coredist=a_pts_coredist(D,d)
    %First D_sort sorted D based on its rows, is created. 
    D_sort=sort(D,2);
    %{
        All elements in the first column of the D_sort are zero, because 
        these elements return the distance between objects from themselves.
        We eliminate this column because we need distance between each object
        and the other objects in the cluster.
    %}
    D_sort(:,1)=[];
    % Finally all-points-core-distace are calculated for all object in the cluster Ci. 
    a_pts_coredist=(sum(((1./D_sort).^d),2)/(size(D,1)-1)).^(-1/d);
end
