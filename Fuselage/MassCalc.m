function[mass] = MassCalc(propertyArray,NumberOfRibs,NumberOfStringers,P)

P = P/NumberOfRibs;

%Densities
rhoSkin = 2000; %CFRP 2000
rhoRib = 2700;%al lithium
rhoStringer = rhoSkin;
YieldStrength = 462e6; %of the frame
%property array = [SkinThickness,StringerThickness,StringerHeight]
SkinThickness = propertyArray(1);
StringerThickness = propertyArray(2);
StringerHeight = propertyArray(3);
StringerWidth = propertyArray(4);



StringerArea = 2*(StringerWidth*StringerThickness)+2*(StringerHeight-StringerThickness)*StringerThickness;
LDStringer =NumberOfStringers*StringerArea*rhoStringer;

%The skin area, and rib area will be variable in the tail and nose, to
%account for additional weight due to reinforcement from cutouts, we will
%just assume the entire fuselage has a constant radius for the weight
%estimate
%fetch the fuselage radius from geoproperties

[totalSpan,NoseRadius,TailRadius,FuselageRadius,fuselageStart,FuselageLength,rrear,rfront] = geoProperties();


Askin = pi*((FuselageRadius^2)-(FuselageRadius-SkinThickness)^2);
LDSkin =Askin*rhoSkin;

%ribs are a bit more complicated, they are at fixed intervals along the
%fuselage
%An estimate for the weight of a single rib, we assume the total area of
%the rib = 1.5 that of the skin area, and the total length of a rib is = to
%the skin thickness

%Frame sizing
frameArea = frameSizer(P,FuselageRadius,YieldStrength,propertyArray(3),propertyArray(1));
Ribweight = frameArea*rhoRib*2*FuselageRadius*pi*NumberOfRibs;


CFRP = totalSpan*(LDStringer+LDSkin)
AL = Ribweight

mass = totalSpan*(LDStringer+LDSkin) + Ribweight;




end

    