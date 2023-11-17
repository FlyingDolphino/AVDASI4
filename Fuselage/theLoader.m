function[x,Q,BM] = theLoader()



    g = 9.81
    Load = csvread('Loads.csv',1,0);
    x = Load(:,1);
    LoadCases = [1,2.5];
    loadPerL = Load(:,2); %the convention is mass is activing negative, eg downwards is -ve
    pointLoads = Load(:,3)*g; %point loads
    
    
    Q = zeros(length(x),2);
    BM = zeros(length(x),2);
    n = LoadCases;
    %find the MAC
    MACindex = find(pointLoads == min(pointLoads));
    MACindex = MACindex(1);
    
    
    
    %FORE FUSELAGE
    frontLoad = loadPerL(1:MACindex); %loads forward of the MAC only
    frontLoad = flipud(frontLoad); %flips it
    Qfront = zeros(MACindex,2);
    for i = 1:MACindex-1
        Q(MACindex-i,:) = -(trapz(x(i:MACindex),frontLoad(i:MACindex))*n*g)-pointLoads(i)*n;
        Qfront(i,:) = Q(MACindex-i,:);
    end
    
    for i = 1:MACindex-1
        BM(MACindex-i,:) = -trapz(x(i:MACindex),Qfront(i:MACindex,:)); 
    end
    
    %REAR FUSELAGE 
    for i = MACindex:length(x)-1
        Q(i,:) = (trapz(x(i:length(x)),loadPerL(i:length(x))*n*g)+pointLoads(i)*n);
        
    end
    
    for i = MACindex:length(x)-1
        BM(i,:) = -trapz(x(i:length(x)),Q(i:length(x)));
    end
    



end
