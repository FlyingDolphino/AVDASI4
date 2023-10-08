close all; clear all;

%Known Values
g = 9.81;
MTOM = 115680;%kg
MFC = 43490;%kg
S = 185.25;%m^2
v = 241.789;%m/s
H = 10668; %in meters
TSFC = 0.0175;%kg/kNs
T = 170.8e3;%thrust at cruise

%calculation values
[t,a,P,rho] = atmosisa(H);
M=v/a;
Q = 0.5*rho*v^2;
Cl = MTOM*g/(Q*S);
Cd = T/(Q*S);





R = a/TSFC * (M*Cl/Cd)*log(MTOM/(MTOM-MFC));
%a is speed of sound at cruise alt, TSFC is the specific fuel consumption



