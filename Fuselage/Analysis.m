function [c,ceq] = Analysis(x,NumberOfFrames,Stringer,Load,Q,BM)
    
    %Material Properties CFRP
    E = 56.25e9;
    v = 0.3;
    YieldStrength = 200e6; %this also needs to be changed in mass calc
    SkinThickness = x(1);
    StringerThickness = x(2);
    StringerHeight = x(3);
    StringerArea = StringerThickness*StringerHeight;
    NumberOfStringers = Stringer;
    [totalSpan,NoseRadius,TailRadius,FuselageRadius,fuselageStart,FuselageLength,rrear,rfront] = geoProperties();
    

    %Loads
   
    P = 64.165e3; %Pa
    x = Load(:,1);
   
    %MAIN PROCESSING SECTION

    %Fuselage setup
    %Goes down the length of the fuselage, working out the stringer spacing
    %at each point, through where the radius is constant, this is trivial
    %however at the nose and tail points this is not. Nose is treated as a
    %spherical cap, tail we assume the radius linear decreases until the end
    %point


    %Frame Geometry setup 
    [buckLength] = FrameAssembly(NumberOfFrames,totalSpan);
    radii = RadiusDistribution(x,FuselageRadius,NoseRadius,TailRadius,fuselageStart,FuselageLength);


    %Perform idealisation for each step in the length
    %init arrays
    B = zeros(NumberOfStringers,length(x));
    b = zeros(length(x),1);
    IxxDistribution = zeros(length(x),1);
    stringerPos = zeros(NumberOfStringers,length(x));


    for j = 1:length(x)


        %Boom and Skin idealisation
        %setup positions
        [stringerPos(:,j),b(j)] = StringerDistribution(NumberOfStringers,radii(j)); 


        %Boom area calculations
        B(:,j)= BoomArea(SkinThickness,b(j),stringerPos(:,j),StringerArea,NumberOfStringers);


        %Second Moment of area contribution from booms only, as they carry
        %the direct stresses
        Ixx = 0;
        for i = 1:NumberOfStringers
            if isnan(B(i))
                Ixx;
            else
                Ixx = Ixx + B(i) * stringerPos(i,j)^2;
            end

        end
        IxxDistribution(j) = Ixx;
    end
    
    

    My=1.0455e7; %Assymetric load case, only applied where the lift is acting as this is due to assymetrical lift as a point moment
    MACindex = find(Q(:,2) == max(Q(:,2))); %finds the MAC
    EIx = E*IxxDistribution;
    

    maxShear = zeros(length(x),2);
    minShear = maxShear;
    maxSigma = maxShear;
    minSigma = maxShear;

    for j = 1:length(x)

        F = Q(j,:); %internal force at the current position
        Mz = BM(j,:); %current BM at the position
        if j~=MACindex
            My = 0;
        end
        

        %Axial Stresses due to bending around the cross section
 
        sigmaZ = zeros(NumberOfStringers,2);
        for i =1:NumberOfStringers
            sigmaZ(i,:) = Mz*stringerPos(i)/IxxDistribution(j);
        end
        
        
        %Shear 
        %Start by finding the open section shear flow
        qb = zeros(NumberOfStringers,1);
        for i = 1:NumberOfStringers
            if i ==1
                qb(i)=0;
            elseif isnan(B(i))
                qb(i)=qb(i-1);

            else            
                qb(i) = B(i)*stringerPos(i,j)+ qb(i-1);
            end

        end

        qb = abs(qb);
        qb = F./IxxDistribution(j) .*qb;
        %work out the closed section shear flow
        A = pi*radii(j)^2;
        Askin = A/NumberOfStringers;
        qs0 = (-F*0 - 2*Askin*sum(qb))/(2*A);
        qs = qb + qs0;
        %Torsion contribution to the shear flow
        %shear flow due to pure torque
        qPureTorsion = My/(2*A);
        qs = qs+qPureTorsion;

        %extract maximum and minimums stresses
        maxShear(j,:) = max(qs)/SkinThickness;
        minShear(j,:) = min(qs)/SkinThickness;
        maxSigma(j,:) = max(sigmaZ);
        minSigma(j,:) = min(sigmaZ);
    end

    

    %Pressure
    d = 2*FuselageRadius;
    t = SkinThickness;  %reassigning variables for easier coding
    longStress = 1.5*P*d/(4*t);
    circumStress = ones(length(x),1)*2*longStress; %this is the max value
    longStrain = P*d/(2*t*E) *(0.5-v);
    circumStrain = P*d/(2*t*E) *(1-0.5*v);
    %VolStrain = P*d/(t*E) *(5/4 -v); %volume percentage increase


    %Buckling
    %Column
    columnCrit = zeros(length(x),1);
    plateCrit = columnCrit;
    crossSectionIx = IxxDistribution + pi/4 *(radii(i)^4-(radii(i)-SkinThickness)^4);
    for i = 1:length(x)

        Area = NumberOfStringers*StringerArea + pi*(radii(i)^2-(radii(i)-SkinThickness)^2);
        gyrationRad = sqrt(crossSectionIx(i)/Area);
        columnCrit(i) =E*(pi^2)/((buckLength/gyrationRad)^2);

        %Plate
        plateCrit(i) = (4*pi^2*E)/(12*(1-v^2)) *(SkinThickness/b(i))^2;


    end

    %stringers as plates
    stringerCrit = 0.43*pi^2*E/(12*(1-v^2)) *(StringerThickness/StringerHeight)^2;



    maxSigma = maxSigma(:,2)*1.5; %selects the higher load case and adds the saftey margin
    minSigma = minSigma(:,2)*1.5;
    maxShear = maxShear(:,2)*1.5;
    minShear = minShear(:,2)*1.5;
    

    %Von mises fail condition WIP
%principal stresses
   
%     sigma1 = (maxSigma + minSigma) / 2 + sqrt(((maxSigma - minSigma) / 2).^2 + maxShear.^2);
%     sigma2 = (maxSigma + minSigma) / 2 - sqrt(((maxSigma - minSigma) / 2).^2 + maxShear.^2);
% 
% 
%     vonMises = sqrt(sigma1.^2 - sigma1.*sigma2 + sigma2.^2 + 3*maxShear.^2);
%     vonFail = vonMises - YieldStrength;

    %Failiure Matrix, if negative, the structure is safe, this is where we
    %include the 1.5 saftey margin

    gyield = (longStress+maxSigma)-YieldStrength;
    gshearyield = (maxShear+circumStress)-YieldStrength;
    c = [gyield,gshearyield, maxSigma-columnCrit, maxSigma-plateCrit,maxSigma-stringerCrit,circumStress-YieldStrength];
    ceq = [];

end