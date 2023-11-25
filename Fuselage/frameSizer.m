function [Area] = frameSizer(P,R,yieldstrength,stringerHeight,SkinThickness)
    
    %This sets the frame size looking at the bending moment distribution
    %around the frame. Takes a force Load, which comes from the maximum
    %vlaue of bending moment
    internalR = 2.140; %minimum radius that needs to be left inside for the cabin
   
    P = abs(P);
    yieldstrength = yieldstrength/1.5; %apply saftey factor
    
    theta = linspace(0,2*pi);
   
    momentDistribution = P*R/(4*pi) .*(2-cos(theta)-2.*(theta).*sin(theta));
    maxM = P*(R-SkinThickness)/(4*pi); %the maximum bending moment present in the frame, located at the bottom surface
    
    
    secondMomentArea = maxM/(yieldstrength);%requited second moment of area
    
    
    
    %future this can be expanded to size the actual stringer dimensions
   
    %Area calculation
    H = (R-internalR)-SkinThickness;
    h = H - 1e-3;
    b = (1/2)*H;
    a = (secondMomentArea -(b/12)*(H^3-h^3))/h^3;

    
    Area = a*h + 2*(b*(H-h));
  

end