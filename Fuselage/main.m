close all
clear all

format compact

%Run this script
%Densities of materials are set in MassCalc
%Geometric information is set in geoProperties
%The main analysis is contained in Analysis

%initial variables, these are just what the optimiser starts at. The bounds
%are set in Optimise
NumberOfFrames = 10; %This does not include the front and rear pressure bulkheads!
NumberOfStringers = 30;
SkinThickness = 5e-3; %m 
StringerThickness =1e-3;%m
StringerHeight = 1e-3;%m
StringerArea = StringerThickness*StringerHeight;

%optimiser
optimum = Optimise(); %returns the lightest structure that withstands the load cases



% In future this will be changed to allow plotting
% Load = csvread('Loads.csv',1,0);
% x = [NumberOfFrames,SkinThickness,StringerThickness,StringerHeight];
% c = Analysis(x,NumberOfStringers,Load);
% 
% 
% %assemble for mass estimation
% structuralProperties = [NumberOfFrames,SkinThickness,StringerThickness,StringerHeight];
% mass = MassCalc(structuralProperties,NumberOfStringers);
