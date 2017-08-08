function y=two2four(x)
    [m,n] = size(x);
    y = zeros(m, n/2);
    
    for a=1:m
        for b=1:2:n
            if (x(a,b)==0 && x(a,b+1)==0)
                y(a,(b+1)/2) = 1;
            elseif (x(a,b)==0 && x(a,b+1)==1)
                y(a,(b+1)/2) = 2;
            elseif (x(a,b)==1 && x(a,b+1)==0)
                y(a,(b+1)/2) = 3;
            else
                y(a,(b+1)/2) = 4;
            end
                
        end
    end
        
end
