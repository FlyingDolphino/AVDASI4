function[totalSpan,NoseRadius,TailRadius,FuselageRadius,fuselageStart,FuselageLength,rrear,rfront] = geoProperties()
    
    %Fuselage fixed parameters
    totalSpan = 46.9;
    NoseRadius = 1250e-3;%m
    TailRadius = (750e-3)/2;%m
    FuselageRadius = 2.3; %m 
    fuselageStart = 5;%m
    FuselageLength = 27.8;%m the constant radius part of the fuselage
    
    %Bulkheads
    rrear = TailRadius;%m rear bulkhead radius
    rfront = NoseRadius;%m front bulkhead radius   

end
