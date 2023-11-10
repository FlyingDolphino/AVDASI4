close all
clear all

%Geometry
%Main Fuselage
FuselageRadius = 1; %m
NumberOfStringers = 16; %number disributed around the circumference
StringerArea  = -100e-6; %m^2
SkinThickness = 2.8e-3; %m 

%Bulkheads
r = 1.25;%m rear bulkhead radius

NoseLength = 1; %distance from the passenger cabin to the tip of the nose
a = 2;%m distance from junction with the pax cabin to the tip
b = FuselageRadius; 


                    
%Material Properties
E = 70e9;
v = 0.3;


%Loads

Mx = 100e3*150; %Nmm applied to the vertical plane
F = 100e3; %N
Fd = 0;   %mm, distance the shear force is applied from the vertical line of symmetry
%this is to be changed to take loads from an excel pending W+B figures

P = 500;

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
d = 2*FuselageRadius;
t = SkinThickness;  %reassigning variables for easier coding

longStress = P*d/4*t;
circumStress = 2*longStress;
longStrain = P*d/(2*t*E) *(0.5-v);
circumStrain = P*d/(2*t*E) *(1-0.5*v);
VolStrain = P*d/(t*E) *(5/4 -v); %volume percentage increase

%Bulkheads
%Rear Bulkhead, assuming its spherical
RBlkStress = P*r/(2*t);

%front bulkhead

dzdx = (-b/a)*(a^2-x^2)^(-0.5)*x;


%FBlkStress = P*raa/(2*t*cos(a));
