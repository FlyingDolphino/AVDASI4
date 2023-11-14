function[mass] = MassCalc(propertyArray,NumberOfStringers)

%Densities
rhoSkin = 2000;
rhoRib = rhoSkin;
rhoStringer = rhoSkin;




%property array = [StringerArea,NumberOfRibs,SkinThickness]

StringerArea = propertyArray(1);
NumberOfRibs = propertyArray(2);
SkinThickness = propertyArray(3);


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
%the rib = 1.5 that of the skin area
ribWeight = 1.5*Askin*rhoRib;
totalRibWeight = ribWeight*NumberOfRibs;


mass = totalSpan*(LDStringer+LDSkin) + totalRibWeight;




end

    