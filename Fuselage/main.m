close all
clear all

format compact

%Run this script
%Densities of materials are set in MassCalc
%Geometric information is set in geoProperties
%The main analysis is contained in Analysis

%initial variables, these are just what the optimiser starts at. The bounds
%are set in Optimise
NumberOfFrames = 20; %This does not include the front and rear pressure bulkheads!
NumberOfStringers = 12;
SkinThickness = 0.2; %m 
StringerThickness =100e-3;%m
StringerHeight = 100e-3;%m

%do not change, these are the final values




%optimiser
optimum = Optimise(); %returns the lightest structure that withstands the load cases



% In future this will be changed to allow plotting
%[position,Q,BM] = theLoader();
%x = [SkinThickness,StringerThickness,StringerHeight];
%c = Analysis(x,NumberOfFrames,NumberOfStringers,position,Q,BM);
% 

%assemble for mass estimation
%structuralProperties = [NumberOfFrames,SkinThickness,StringerThickness,StringerHeight];
%mass = MassCalc(structuralProperties,NumberOfStringers);
