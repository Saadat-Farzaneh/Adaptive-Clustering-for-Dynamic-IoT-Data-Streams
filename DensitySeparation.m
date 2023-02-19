function Cluster=DensitySeparation(Cluster,d)
 
    nCla=size(Cluster,1);
    
    DSPC=zeros(nCla);
    
    
    for i=1:nCla
        
        for j=i+1:nCla
            NodesDij=pdist2(Cluster(i).InternalNodePoints,...
                   Cluster(j).InternalNodePoints);
            
            % To calculate Density Separation, it is needed that 
            % all-points-core-distance of members of the ith cluster be
            % calculated base on members of the jth cluster, and vice versa.
            a_pts_coredist_i_baseon_j=...
                (sum(((1./NodesDij).^d),2)/size(NodesDij,2)).^(-1/d);
            
            a_pts_coredist_j_baseon_i=...
                (sum(((1./NodesDij).^d),1)/size(NodesDij,1)).^(-1/d);
            %    
            MRDij=zeros(size(NodesDij));
            
            for h=1:size(NodesDij,1)
                
                for k=1:size(NodesDij,2)
                    MRDij(h,k)=...
                        max([a_pts_coredist_i_baseon_j(h),...
                        a_pts_coredist_j_baseon_i(k),...
                        NodesDij(h,k)]);
                end
                
            end
            
            DSPC(i,j)=min(MRDij(:));
            DSPC(j,i)=DSPC(i,j);
            clear NodesDij MRDij
        end
    end
    
    
    DSPC=sort(DSPC,2);
    
    DSPC=DSPC(:,2);
    
    for z=1:nCla
        Cluster(z).minDSPC=DSPC(z);
    end
                    
end
   