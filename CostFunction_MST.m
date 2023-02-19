function [z,A]=CostFunction_MST(x,MDR)
      
    A=squareform(x);
    
    q=CalcDisconnectivity2(A);
    
    AD=A.*MDR;
    
    alpha=10*sum(MDR(:));
    %alpha=realmax;
    
    z=sum(AD(:))+q*alpha;
    
 end