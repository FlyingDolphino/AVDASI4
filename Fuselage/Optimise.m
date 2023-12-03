function[optimum] = Optimise()
    

    %initial variables, variables set by optimiser. Stringers are assumed
    %to be top hat shaped
    
    SkinThickness = 0.0021; %m 
    StringerThickness =0.002;%m
    StringerHeight = 0.02;%m
    StringerWidth = 0.02e-3;%m
    NumberOfFrames = 85;

    lb=[0.5e-3,2e-3,20e-3,20e-3];
    ub=[8e-3,3e-3,35e-3,35e-3];

    %Loads internal forces and moments
    [position,Q,BM] = theLoader();
    

    %sets checking variables
    opt = 1e50;
    smallest = 0;
    x = [SkinThickness,StringerThickness,StringerHeight,StringerWidth];
    
    
    for i = 78:78
        Stringer = i;
        x0 = x;

        nonLinearConstraint = @(x) Analysis(x,NumberOfFrames,Stringer,position,Q,BM);
        options = optimoptions(@fmincon,'Display','iter','MaxFunctionEvaluations',4e10,'MaxIterations',5e10);
        [results(i,:), fval,exitflag] = fmincon(@(x)MassCalc(x,NumberOfFrames,Stringer,max(Q(:,2))),x0,[],[],[],[],lb,ub,nonLinearConstraint,options);

        if opt > fval && exitflag>0
            opt = fval;
            smallest = i;
        end
    end
    optimum = [results(smallest,:) smallest, opt];

end
