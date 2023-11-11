function [B] = BoomArea(t,b,y,A,N)
%Calculates the boom areas

B = zeros(N,1);
for i = 1:N
        
    if i ==1 
        B(i) = A + ((t*b)/6)*(2 + y(i+1)/y(i)) + ((t*b)/6)*(2 + y(end)/y(i));
    
    elseif i == N
        B(i) = A + ((t*b)/6)*(2 + y(1)/y(i)) + ((t*b)/6)*(2 + y(i-1)/y(i));  
        
    else
        B(i) = A + ((t*b)/6)*(2 + y(i+1)/y(i)) + ((t*b)/6)*(2 + y(i-1)/y(i));
        
    end
       
end

end
