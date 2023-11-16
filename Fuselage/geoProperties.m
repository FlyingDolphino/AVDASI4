function[totalSpan,NoseRadius,TailRadius,FuselageRadius,fuselageStart,FuselageLength,rrear,rfront] = geoProperties()
    
    %Fuselage fixed parameters
    totalSpan = 46.9;
    NoseRadius = 1250e-3;%m
    TailRadius = (750e-3)/2;%m
    FuselageRadius = 2.2895; %m 
    fuselageStart = 5;%m
    FuselageLength = 27.8;%m the constant radius part of the fuselage
    
    %Bulkheads
    rrear = 1.25;%m rear bulkhead radius
    rfront = 1.25;%m front bulkhead radius   

end
