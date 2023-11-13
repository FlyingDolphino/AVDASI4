function[radii] = RadiusDistribution(x,fuselageRadius,rfront,minr,StartX,fuselageLength)

radii = zeros(length(x),1);

%Nose portion
%This varies from the radius of the front bulkhead to the main passegner
%cabin
gradNose = (fuselageRadius-rfront)/StartX;


%Tail
xTailStart = StartX+fuselageLength;
tailGrad = (minr-fuselageRadius)/(46.9-xTailStart);

for i = 1:length(x)
    if x(i) < StartX
        radii(i) = rfront + gradNose*x(i);
    elseif x(i) > StartX && x(i) < xTailStart
        radii(i) = fuselageRadius;
    else
        radii(i) = fuselageRadius + tailGrad*(x(i)-xTailStart);
    end
    
    
end
