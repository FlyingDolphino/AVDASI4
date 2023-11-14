close all
clear all

g=9.81;

%initial variables, these are just what the optimiser starts at
NumberOfFrames = 40; %This does not include the front and rear pressure bulkheads!
NumberOfStringers = 30;
SkinThickness = 5e-3; %m 
StringerThickness =1e-3;%m
StringerHeight = 1e-3;%m
StringerArea = StringerThickness*StringerHeight;

%analysis is called
x = [NumberOfFrames,SkinThickness,StringerThickness,StringerHeight];
c = Analysis(x,NumberOfStringers);


%assemble for mass estimation
structuralProperties = [StringerArea,NumberOfFrames,SkinThickness];
mass = MassCalc(structuralProperties,NumberOfStringers);
