function [Area] = frameSizer(P,R,yieldstrength)
    
    %This sets the frame size looking at the bending moment distribution
    %around the frame. Takes a force Load, which comes from the maximum
    %vlaue of bending moment
    P = abs(P);
    yieldstrength = yieldstrength*1.5; %apply saftey factor
     
    theta = linspace(0,2*pi);
   
    momentDistribution = P*R/(4*pi) .*(2-cos(theta)-2.*(theta).*sin(theta));
    Na = 3*P/(4*pi)*1.5 ;%normal force in the frame
    
    
    
    Area = Na/yieldstrength; %minimum area required as to not fail
    
    %future this can be expanded to size the actual stringer dimensions
   
    

end