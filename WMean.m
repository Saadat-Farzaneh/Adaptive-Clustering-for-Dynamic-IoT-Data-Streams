%{
    This function returns a weighted mean of some values in vector X that
    their probability density function values are in vector f. We calculate
    expected value as a weighted mean of values of X. 
%}
function Evalue=WMean(x,f)
 
    % To calculate expected value we must calculate integral of xf(x). 
    % To calculate this integral we use the composite trapezoidal rule
     
    xfx=x.*f;
     
    n=length(xfx);
     
    Evalue=((x(n)-x(1))/n)*(xfx(1)/2+sum(xfx(2:n-1))+xfx(n)/2);
     
    end
    