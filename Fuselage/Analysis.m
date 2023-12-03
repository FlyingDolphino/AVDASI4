function [c,ceq] = Analysis(x,NumberOfFrames,Stringer,Load,Q,BM)
    
    %Material Properties CFRP
    E = 93.75e9; %93.75e9
    v = 0.23;  %0.23
    G = E/(2*(1+v));
    YieldStrength = 1.5e9; % 1.5e9
    ShearStrength = 207e6;
    SkinThickness = x(1);
    StringerThickness = x(2);
    StringerHeight = x(3);
    StringerWidth = x(4);
    NumberOfStringers = Stringer;
    MACindex = find(Q(:,2)==max(Q(:,2)));
    
    
    StringerArea = 2*(StringerWidth*StringerThickness)+2*(StringerHeight-StringerThickness)*StringerThickness;
    [totalSpan,NoseRadius,TailRadius,FuselageRadius,fuselageStart,FuselageLength,rrear,rfront] = geoProperties();
    buckLength = FrameAssembly(NumberOfFrames,totalSpan);
    
    
    
    %Variable Initialisation
    lenx = length(Load);
    pos = Load(:,1);
    radii = RadiusDistribution(pos,FuselageRadius,NoseRadius,TailRadius,fuselageStart,FuselageLength);
    maxSigma = zeros(lenx,1);
    minSigma = maxSigma;
    maxShear = maxSigma;
    minShear = maxSigma;
    columnCrit = zeros(length(pos),1);
    plateCrit = columnCrit;
    stringerCrit= columnCrit;
    
    %Performing the Analysis over the entire length of the cross section
    
    for j = 1:length(Load)
        
        B = zeros(NumberOfStringers,1);
        %Step 1, Boom and Skin Approximation
        [stringerPos,b] = StringerDistribution(NumberOfStringers,radii(j)); %Place Stringers
        B = BoomArea(SkinThickness,b,stringerPos,StringerArea,NumberOfStringers);   %Boom Area
        
        %Find idealised section Ixx
        Ixx = 0;
        for i =1:NumberOfStringers
            if ~isnan(B(i))
                Ixx = Ixx + B(i)*stringerPos(i)^2;
            end
            
        end
        
        
        %extract Q and M at the current position and process other loads
        P = 64.165e3;
        F = Q(j,:);
        M = BM(j,:);
        if j == MACindex
            My = 1.4055e7; %assymetric loading case;
        end
        
        
        
        
        %Shear Flow
        qb = zeros(NumberOfStringers,1);
        
        %First calculated assuming no force is applied
        for i=2:NumberOfStringers
            if isnan(B(i))
                qb(i) = qb(i-1);
            else
                qb(i) = B(i)*stringerPos(i)+qb(i-1);
            end
        end
        qb = -(F/Ixx).*qb; %open section shear flow
        panelArea = (pi*radii(j)^2)/NumberOfStringers;
        qs0 = -2*panelArea*sum(qb)/(2*panelArea);
        qs = qb+qs0;
        
        
        %Stress Distribution
        sigma = zeros(NumberOfStringers,2);
        shear = qs/SkinThickness;
        for i = 1:NumberOfStringers
            sigma(i,:) = -M*stringerPos(i)/Ixx;
        end
        
        
        maxSigma(j) = max(sigma(:,2));
        minSigma(j) = min(sigma(:,1));
        maxShear(j) = max(shear(:,2));
        minShear(j) = min(shear(:,1));
      
   
        
        %Buckling Calcs
        A = 0.5*((pi*radii(j)^2)-(pi*(radii(j)-SkinThickness)^2));
        compressionInd = find(stringerPos<=0);
        d = 4*radii(j)/(3*pi);
        compressionMemPos = stringerPos(compressionInd(1:end))+d;
        boomAreas = BoomArea(SkinThickness,b,compressionMemPos,StringerArea,length(compressionMemPos));
        
        
        columnIx = nansum(boomAreas.*compressionMemPos.^2);
        
       
        Gr = sqrt(columnIx/A);
        columnCrit(j) = 0.5*E*(pi^2)/(buckLength/Gr)^2;
        
        plateCrit(j) =(4*pi^2*E)/(12*(1-v^2)) *(SkinThickness/b)^2;
 
        stringerCrit(j) =  0.43*pi^2*E/(12*(1-v^2)) *(StringerThickness/StringerHeight)^2;
        
    end
    
    
    %Pressure
    d = 2*FuselageRadius;
    t = SkinThickness;  %reassigning variables for easier coding
    longStress = 1.5*P*d/(4*t);
    circumStress = ones(length(pos),1)*2*longStress; %this is the max value
    
  
    
    %compiling failiure matrix
    %Applying 1.5 sf
    YieldStrength = YieldStrength/1.5;
    ShearStrength = ShearStrength/1.5;
    columnCrit = columnCrit/1.5;
    plateCrit=plateCrit/1.5;
    stringerCrit = stringerCrit/1.5;
    
    c = [maxSigma-YieldStrength,maxShear-ShearStrength,abs(minSigma)-columnCrit,abs(minSigma)-plateCrit,abs(minSigma)-stringerCrit,circumStress-ShearStrength];
    
    ceq =[];
    


end