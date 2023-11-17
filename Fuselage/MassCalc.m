function[mass] = MassCalc(propertyArray,NumberOfRibs,NumberOfStringers,P)

%Densities
rhoSkin = 2000;
rhoRib = rhoSkin;
rhoStringer = rhoSkin;
YieldStrength = 7e9;
%property array = [SkinThickness,StringerThickness,StringerHeight]

StringerArea = propertyArray(2)*propertyArray(3);
SkinThickness = propertyArray(1);


LDStringer =NumberOfStringers*StringerArea*rhoStringer;

%The skin area, and rib area will be variable in the tail and nose, to
%account for additional weight due to reinforcement from cutouts, we will
%just assume the entire fuselage has a constant radius for the weight
%estimate
%fetch the fuselage radius from geoproperties

[totalSpan,NoseRadius,TailRadius,FuselageRadius,fuselageStart,FuselageLength,rrear,rfront] = geoProperties();


Askin = pi*((FuselageRadius^2)-(FuselageRadius-SkinThickness)^2);
LDSkin =Askin*rhoSkin*SkinThickness;

%ribs are a bit more complicated, they are at fixed intervals along the
%fuselage
%An estimate for the weight of a single rib, we assume the total area of
%the rib = 1.5 that of the skin area, and the total length of a rib is = to
%the skin thickness

%Frame sizing
frameArea = frameSizer(P,FuselageRadius,YieldStrength);
ribWeight = frameArea*rhoRib*2*FuselageRadius*pi*NumberOfRibs;

mass = totalSpan*(LDStringer+LDSkin) + ribWeight;




end

    