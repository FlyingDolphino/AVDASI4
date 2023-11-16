function [frameSize] = frameSizer(P,R,yieldstrength)
    
    %This sets the frame size looking at the bending moment distribution
    %around the frame. Takes a force Load, which comes from the maximum
    %vlaue of bending moment
    
    
    theta = linspace(0,2*pi);
    
    momentDistribution = P*R/(4*pi) .*(2-cos(theta)-2.*(theta).*sin(theta));
    
    %sigmaDistribution = -MomentDistribution/Ix; %bending stress
    
    My = -momentDistribution .*sin(theta).*R;  
    
    IxRequired = max(My)*1.5/yieldstrength;
    
    r = (R^4 - 4*IxRequired/pi)^(1/4); %works out the inner radius of the frame;
    t = R-r;
    
    Na = 3*P/(4*pi)*1.5 ;%normal force in the frame
    
    area = Na/yieldstrength;%calculate cross section area 
    frameDepth = area/t;
    frameThickness = t;
    
    frameSize=[frameThickness,frameDepth]; % [frameThickness, frameDepth]
    

end