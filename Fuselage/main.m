close all
clear all

g=9.81;

%Geometry
%Main Fuselage
FuselageRadius = 2.2895; %m 
fuselageStart = 5;%m
FuselageLength = 27.8;%m the constant radius part of the fuselage
NumberOfFrames = 0; %This does not include the front and rear pressure bulkheads! 
SkinThickness = 2.8e-3; %m 
NumberOfStringers = 16; %number disributed around the circumference, assumed to be rectangular
StringerThickness =1e-3;%m
StringerHeight = 1e-3;%m
StringerArea  = StringerHeight*StringerThickness; %m^2

%Bulkheads
rrear = 1.25;%m rear bulkhead radius
rfront = 1.25;%m front bulkhead radius            




%Material Properties
E = 70e9;
v = 0.3;
YieldStrenght = 1;



%Loads
P = 500;
Load = csvread('Loads.csv',1,0);
x = Load(:,1);
massperL = Load(:,2);





%DEPRECATED
Mx = 0; %Nmm applied to the vertical plane
F = 0; %N
Fd = 0;   %mm, distance the shear force is applied from the vertical line of symmetry
%this is to be changed to take loads from an excel pending W+B figures




%MAIN PROCESSING SECTION

%Call Optimiser here


%Result Analysis

%Fuselage setup
%Goes down the length of the fuselage, working out the stringer spacing
%at each point, through where the radius is constant, this is trivial
%however at the nose and tail points this is not. Nose is treated as a
%spherical cap, tail we assume the radius linear decreases until the end
%point



%Frame Geometry setup 
[framePos,buckLength] = FrameAssembly(NumberOfFrames,FuselageLength);


%Boom and Skin idealisation
%setup positions
[stringerPos,b] = StringerDistribution(NumberOfStringers,FuselageRadius); 

%Boom area calculations
B= BoomArea(SkinThickness,b,stringerPos(:,2),StringerArea,NumberOfStringers);


%Second Moment of area
Ixx = 0;
for i = 1:NumberOfStringers
    if isnan(B(i))
        Ixx;
    else
        Ixx = Ixx + B(i) * stringerPos(i,2)^2;
    end

end

EIx = E*Ixx;
Q = zeros(length(x),1);
BM = zeros(length(x),1);
%Internal forces
for i = 1:length(x)-1
    Q(i) = (-trapz(x(i:length(x)),massperL(i:length(x)))*g);
   
end

%IBM
for i = 1:length(x)-1 
        BM(i) = -trapz(x(i:length(x)),Q(i:length(x))); 
end





maxShear = zeros(length(x),1);
minShear = maxShear;
maxSigma = maxShear;
minSigma = maxShear;
for j = 1:length(x)
    
    %Does stress calculations for each point along the fuselage for the
    %constant raidus portion only, as this is where failiure would occur
    
    %Takes the maximum stress present in the cross section
    
    F = Q(i); %internal force at the current position
    Mx = BM(i); %current BM at the position
    
    if x(j) > fuselageStart && x(j) < fuselageStart+FuselageLength
        
        %Axial Stresses due to bending (asym loading case)
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
        %Torsion contribution to the shear flow
        %shear flow due to pure torque
        qPureTorsion = Mx/(2*A);
        qs = qs+qPureTorsion;
        
        %extract maximum and minimums
        maxShear(j) = max(qs);
        minShear(j) = min(qs);
        maxSigma(j) = max(sigmaZ);
        minSigma(j) = min(sigmaZ);
        
    else
        %we are in the pressure bulkheads, and dont analysis failure at
        %these points
        maxShear(j) = 0;
        minShear(j) = 0;
    
    end
        
end

    


%Pressure
d = 2*FuselageRadius;
t = SkinThickness;  %reassigning variables for easier coding
longStress = P*d/4*t;
circumStress = 2*longStress;
longStrain = P*d/(2*t*E) *(0.5-v);
circumStrain = P*d/(2*t*E) *(1-0.5*v);
VolStrain = P*d/(t*E) *(5/4 -v); %volume percentage increase

%Bulkheads, Assuming both a spherical for simplicity
%Rear Bulkhead
RBlkStress = P*rrear/(2*t);

%front bulkhead
FBlkStress = P*rfront/(2*t);


%Buckling
%Column
Area = NumberOfStringers*StringerArea + pi*(FuselageRadius^2-(FuselageRadius-SkinThickness)^2);
gyrationRad = sqrt(Ixx/Area);
columnCrit = pi^2*E/(buckLength/gyrationRad)^2;

%Plate
b = double(b);
plateCrit = 4*pi^2*E/(12*(1-v^2)) *(SkinThickness/b)^2;

%stringers as plates
stringerCrit = 0.43*pi^2*E/(12*(1-v^2)) *(StringerThickness/StringerHeight)^2;


%Von mises fail condition WIP
%principal stresses
tau_max = maxShear;
sigma1 = (maxSigma + minSigma) / 2 + sqrt(((maxSigma - minSigma) / 2).^2 + tau_max.^2);
sigma2 = (maxSigma + minSigma) / 2 - sqrt(((maxSigma - minSigma) / 2).^2 + tau_max.^2);


vonMises = sqrt(sigma1.^2 - sigma1.*sigma2 + sigma2.^2 + 3*tau_max.^2);
vonFail = vonMises - YieldStrength;

