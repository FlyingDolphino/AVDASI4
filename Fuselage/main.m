close all
clear all

%Geometry
FuselageRadius = 381;
NumberOfStringers = 16; %number disributed around the circumference
StringerArea  = 100; %mm^2
SkinThickness = 0.8; %mm 

                    
%Material Properties

%Loads

%Boom and Skin idealisation
%setup positions
[stringerPos,b] = StringerDistribution(NumberOfStringers,FuselageRadius); 

%Boom area calculations
B = zeros(NumberOfStringers,1);
for i = 1:NumberOfStringers
        
    if i ==1 
        B(i) = StringerArea + ((SkinThickness*b)/6)*(2 + stringerPos(i+1,2)/stringerPos(i,2)) + ((SkinThickness*b)/6)*(2 + stringerPos(end,2)/stringerPos(i,2));
    
    elseif i == NumberOfStringers
        B(i) = StringerArea + ((SkinThickness*b)/6)*(2 + stringerPos(1,2)/stringerPos(i,2)) + ((SkinThickness*b)/6)*(2 + stringerPos(i-1,2)/stringerPos(i,2));  
        
    else
        B(i) = StringerArea + ((SkinThickness*b)/6)*(2 + stringerPos(i+1,2)/stringerPos(i,2)) + ((SkinThickness*b)/6)*(2 + stringerPos(i-1,2)/stringerPos(i,2));
        
    end
       
end

%Second Moment of area
Ixx = 0;
for i = 1:NumberOfStringers
    if isnan(B(i))
        Ixx = Ixx;
    else
        Ixx = Ixx + B(i) * stringerPos(i,2)^2;
    end
      
end



%Bending