close all;
clear all;

%input parameters
Vstall =  55.2;%m/s,approach speed = 1.3* the stall speed
M = 0.73; %Climb mach
H = 10058.4;%Cruise altitude 
maxH = 12496.8; %ceiling altitude
climb = 6;%minimum climb rate required to reach the cruise altitude
Clmax =2.5; %Largely decided by the high lift device we use, could be higher 
Clcruise = 1;
takeoffRoll = 1666.5; %meter
landRoll = 1300;
Cd0 = 0.0373;
e = 0.8;
AR = 11;



%landing speed constraint
Q = 0.5*1.225*Vstall^2;
wsLanding = Q*Clmax/9.81;


%takeoff roll
wrRange = (0:1:1.3*wsLanding);
vTo = 1.1*Vstall;
Q = 0.5*1.225*vTo;
twTakeoff = ((vTo^2 )/(2*9.81*takeoffRoll) + 1./(wrRange) *((Q*Cd0+ Q*Clmax^2)/(pi*AR*e))+0.03);

%climb requirement
[T,a,P,rho] = atmosisa(H);
vCruise = a*M;
gradient = 1.524/vCruise;
sigma = (20-H)/(20+H);
twClimb = ((0.5*1.225*vCruise^2*Cd0)./(wrRange) + (wrRange)./(0.5*1.225*sigma^2*vCruise^2*pi*AR*e)+ gradient/sigma);

%ceiling constraint
[T,a,P,rho] = atmosisa(maxH);
vCeiling = a*M;
Q = 0.5*1.225*vCeiling;
wsCeiling = Q*Clcruise;




%plotting
plot(wrRange,twTakeoff);
hold on;
plot(wrRange,twClimb/9.81);
xline(wsLanding,'g');
xline(wsCeiling);
ylim([0 1]);
xlabel('W/S');
ylabel('T/W');
legend('T/O distance','Climb','Stall Speed','Ceiling');

