function[optimum] = Optimise()
    
    %initial variables, these are just what the optimiser starts at
    NumberOfFrames = 30; %This does not include the front and rear pressure bulkheads! 
    SkinThickness = 6e-3; %m 
    StringerThickness =6e-3;%m
    StringerHeight = 6e-3;%m
    
 
    %sets checking variables
    fvalCheck= 1e50;
    smallest = 0; %this would store the mass
    Load = csvread('Loads.csv',1,0);
    
    for i = 2:30
        Stringer = i;
        x0 =[NumberOfFrames,SkinThickness,StringerThickness,StringerHeight];
        lb=[2,2e-3,2e-3,2e-3];
        ub=[60,0.5,0.5,0.5];

        nonLinearConstraint = @(x) Analysis(x,Stringer,Load);
        options = optimoptions(@fmincon,'Display','iter','MaxFunctionEvaluations',4e10,'MaxIterations',5e10);
        [results(i,:), fval,exitflag] = fmincon(@(x)MassCalc(x,Stringer),x0,[],[],[],[],lb,ub,nonLinearConstraint,options);
        
        if fvalCheck > fval && exitflag>0
            fvalCheck = fval;
            smallest = i;
        end
            
        
        
    end
    
    
    optimum = [results(smallest,:), (smallest) fvalCheck];
        

end
