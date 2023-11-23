function [Area] = frameSizer(P,R,yieldstrength,stringerHeight)
    
    %This sets the frame size looking at the bending moment distribution
    %around the frame. Takes a force Load, which comes from the maximum
    %vlaue of bending moment
    P = abs(P);
    yieldstrength = yieldstrength/1.5; %apply saftey factor
    E = 76.5e9; 
    theta = linspace(0,2*pi);
   
    momentDistribution = P*R/(4*pi) .*(2-cos(theta)-2.*(theta).*sin(theta));
    maxM = P*R/(4*pi); %the maximum bending moment present in the frame, located at the bottom surface
    
    
    secondMomentArea = maxM*1.5/(yieldstrength*E);%requited second moment of area
    
    
    
    %future this can be expanded to size the actual stringer dimensions
   
    %Area calculation
    
    H = 2*stringerHeight; %impose a fixed height to allow the stringers to pass through
    h = H - 1.5e-3;
    b = (1/3)*H;
    a = (secondMomentArea - 12*b*(H^3-h^3)/12)/(h^3);
    if a < 10e-2
        a = 10e-2
    end
    
    Area = a*h + 2*(b*(H-h));

end