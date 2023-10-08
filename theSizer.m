clear all;
close all;

%constants
g = 9.81;


%aircraft configuration
Pax = 170;
HD = 0; %sets if high desnity, this leaves carry on and checked in non-differentiated
A = 0.97;%typical values for a jet transport a/c
C = -0.06;
Kvs =1.00; %1 for conventional fixed wing, 1.04 for a variable sweep
Wo = 100000; %initial estimation for take off weight
LdMax = 22; %L/Dmax estimate
TSFCCruise = 14.1e-6; %kg/s
TSFCLoiter = 11.3e-6;
RFF = 0.1; %reserve fuel fraction range 0.06-0.1


%mission leg settings
Vmd = 113.178; %used for holding speed
M = 0.8; %cruise mach;
cruiseAlt = 12496.8;%meters
cruiseRange = 7778400;%meters
holdingTime = 30; %mins
takeoffFraction = 0.970;
climbFraction = 0.985;
approachFraction = 0.995;

%Pax weight settings by EASA by deafult
kgPax = 86; %kg per passenger, this includes carry on
kgChecked = 17;%kg per passenger, not included for HD

%payload calculation
if HD ==0
    PL = kgPax*Pax + kgChecked*Pax;
else
    PL = kgPax*Pax;

end

dif = 10;
while abs(dif) > 0

    %OEW
    fractionOEW = A*(Wo^C)*Kvs;
    %Fuel weight

    %BRE legs
    %cruise
    [T,a,P,rho] = atmosisa(cruiseAlt);
    v = a*M;

    w32 = exp(-(g*TSFCCruise*cruiseRange)/(v*0.866*LdMax));

    %diversion 
    [T,a,P,rho] = atmosisa(6096);
    v = a*0.6;

    w65 = exp(-(g*TSFCCruise*370400)/(v*0.866*LdMax));

    %loiter/hold
    w76 = exp(-(g*TSFCLoiter*1800)/(0.866*LdMax));

    %total weight fraction
    w80 = 0.97*0.985*w32*1*0.995*w65*w76*0.995;

    %MTOW calc
    MTOW = PL/(1-(fractionOEW + (1+RFF)/0.95 *(1-w80)));
    dif = Wo-MTOW;
    Wo = MTOW;
end


MTOW

