close all
clear all

%Geometry
FuselageRadius = 381;
NumberOfStringers = 16; %number disributed around the circumference
StringerArea  = -100; %mm^2
SkinThickness = 0.8; %mm 

                    
%Material Properties

%Loads

Mx = 100e3*150; %Nmm applied to the vertical plane
F = 100e3; %N
Fd = 0;   %mm, distance the shear force is applied from the vertical line of symmetry
%this is to be changed to take loads from an excel pending W+B figures


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


%Stresses due to bending
sigmaZ = zeros(NumberOfStringers,1);
for i =1:NumberOfStringers
    sigmaZ(i) = Mx*stringerPos(i,2)/Ixx;
end

%Shear
%Start by finding the open section shear flow
qb = zeros(NumberOfStringers,1);
for i = 1:NumberOfStringers
    if i ==1
        qb(i)=0;
    elseif isnan(B(i))
        qb(i)=qb(i-1);
    else

        qb(i) = B(i)*stringerPos(i,2)+ qb(i-1);
    end
    
end
qb = -F/Ixx *qb;

%work out the closed section shear flow
A = pi*FuselageRadius^2;
Askin = A/16;
qs0 = (-F*Fd - 2*Askin*sum(qb))/(2*A);
qs = qb + qs0;

%Torsion
%shear flow due to pure torque
qPureTorsion = Mx/(2*A);
qs = qs+qPureTorsion;


%Pressure

