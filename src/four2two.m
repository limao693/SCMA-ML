function xn=four2two(yn)
    [x, y] = size(yn);
    xn = zeros(x, y*2);
    for n = 1:x
        for m = 1:y
            switch (yn(n, m))
                case 1
                    xn(n, 2*m-1) = 0;
                    xn(n, 2*m) = 0;
                case 2
                    xn(n, 2*m-1) = 0;
                    xn(n, 2*m) = 1;
                case 3
                    xn(n, 2*m-1) = 1;
                    xn(n, 2*m) = 0;  
                case 4
                    xn(n, 2*m-1) = 1;
                    xn(n, 2*m) = 1;
            end
    end
    
end
