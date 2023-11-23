function[opt] = Optimise()
    

    %initial variables, these are just what the optimiser starts at
    SkinThickness = 0.04; %m 
    StringerThickness =0.1;%m
    StringerHeight = 0.015;%m
    

    %sets checking variables
    
    smallest = 0; %this would store the mass

    
    
    %Internal forces, centered at the MAC. 
    [position,Q,BM] = theLoader();
    

    opt = 1e50;
    
    for j = 20:50
    NumberOfFrames = j;
    fvalCheck= 1e50;
        for i = 10:25 %Boom and skin idealisation is only valid if the distance between booms is small, therefore minimum stringers must meet this condition
            Stringer = i;
            x0 =[SkinThickness,StringerThickness,StringerHeight];
            lb=[1e-3,1e-2,1e-2];
            ub=[0.08,0.05,0.03475];

            nonLinearConstraint = @(x) Analysis(x,NumberOfFrames,Stringer,position,Q,BM);
            options = optimoptions(@fmincon,'Display','iter','MaxFunctionEvaluations',4e10,'MaxIterations',5e10,'algorithm','sqp');
            [results(i,:), fval,exitflag] = fmincon(@(x)MassCalc(x,NumberOfFrames,Stringer,min(BM(:,2))),x0,[],[],[],[],lb,ub,nonLinearConstraint,options);

            if fvalCheck > fval && exitflag>0
                fvalCheck = fval;
                smallest = i;
            end
            
            
        end
        if smallest == 0
            opt;
        
        else
            frameopt = [results(smallest,:),smallest,j,fvalCheck];
            
            if frameopt(end) < opt(end)
                opt = frameopt;
            end
        end
        
        
    end
    
    
    
        

end
