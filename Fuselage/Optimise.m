function[optimum] = Optimise()
    
    %initial variables, these are just what the optimiser starts at
    NumberOfFrames = 40; %This does not include the front and rear pressure bulkheads! 
    SkinThickness = 15e-3; %m 
    StringerThickness =1e-3;%m
    StringerHeight = 1e-3;%m
    StringerArea  = StringerHeight*StringerThickness; %m^2
 
    %sets checking variables
    fvalCheck= 1e50;
    smallest = 0; %this would store the mass
    
    for i = 2:25
        Stringer = i;
        x0 =[NumberOfFrames,SkinThickness,StringerArea];
        lb=[2,1e-3,1e-6];
        ub=[60,0.5,1e-3];

        nonLinearConstraint = @(x) Analysis(x,Stringer);
        options = optimoptions(@fmincon,'Display','iter','MaxFunctionEvaluations',4e10,'MaxIterations',5e10, 'function', 'sql');
        [results(i,:), fval] = fmincon(@(x)MassCalc(x,Stringer),x0,[],[],[],[],lb,ub,nonLinearConstraint,options);
        
    end
    

end
