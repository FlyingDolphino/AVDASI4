function[optimum] = Optimise()
    
    g= 9.81;

    %initial variables, these are just what the optimiser starts at
    SkinThickness = 2e-3; %m 
    StringerThickness =2e-3;%m
    StringerHeight = 2e-3;%m
    

    %sets checking variables
    fvalCheck= 1e50;
    smallest = 0; %this would store the mass
    Load = csvread('Loads.csv',1,0);
    LoadCases = [1,2.5];
    x = Load(:,1);
    loadPerL = Load(:,2); %the convention is mass is activing negative, eg downwards is -ve
    Q = zeros(length(x),2);
    BM = zeros(length(x),2);
    n = LoadCases;
    
    
    %Internal forces, centered at the MAC. 
    %find the MAC
    MACindex = find(loadPerL == min(loadPerL));
    
    %FORE FUSELAGE
    frontLoad = loadPerL(1:MACindex); %loads forward of the MAC only
    frontLoad = flipud(frontLoad); %flips it
    Qfront = zeros(MACindex,2);
    for i = 1:MACindex-1
        Q(MACindex-i,:) = (trapz(x(i:MACindex),frontLoad(i:MACindex))*n*g);
        Qfront(i,:) = Q(MACindex-i,:);
    end
    
    for i = 1:MACindex-1
        BM(MACindex-i,:) = -trapz(x(i:MACindex),Qfront(i:MACindex,:)); 
    end
    
    %REAR FUSELAGE 
    for i = MACindex:length(x)-1
        Q(i,:) = -(trapz(x(i:length(x)),loadPerL(i:length(x))*n*g));
        
    end
    
    for i = MACindex:length(x)-1
        BM(i,:) = trapz(x(i:length(x)),Q(i:length(x)));
    end
    


    frameSmallest = [];
    for j = 2:60
    NumberOfFrames = j;
        for i = 2:30
            Stringer = i;
            x0 =[SkinThickness,StringerThickness,StringerHeight];
            lb=[1e-3,1e-3,1e-3];
            ub=[0.5,0.5,0.5];

            nonLinearConstraint = @(x) Analysis(x,NumberOfFrames,Stringer,Load,Q,BM);
            options = optimoptions(@fmincon,'Display','iter','MaxFunctionEvaluations',4e10,'MaxIterations',5e10);
            [results(i,:), fval,exitflag] = fmincon(@(x)MassCalc(x,NumberOfFrames,Stringer,max(BM(:,2))),x0,[],[],[],[],lb,ub,nonLinearConstraint,options);

            if fvalCheck > fval && exitflag>0
                fvalCheck = fval;
                smallest = i;
            end
        end
    frameSmallest(j-1,:) = [results(smallest,:), (smallest), (j), fvalCheck];
        
    end
    
    
    
        

end
