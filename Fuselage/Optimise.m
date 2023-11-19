function[opt] = Optimise()
    

    %initial variables, these are just what the optimiser starts at
    SkinThickness = 0.03; %m 
    StringerThickness =1e-3;%m
    StringerHeight = 1e-3;%m
    

    %sets checking variables
    fvalCheck= 1e50;
    smallest = 0; %this would store the mass

    
    
    %Internal forces, centered at the MAC. 
    [position,Q,BM] = theLoader();
    

    opt = 1e50;
    
    for j = 20:40
    NumberOfFrames = j;
        for i = 10:30 %Boom and skin idealisation is only valid if the distance between booms is small, therefore minimum stringers must meet this condition
            Stringer = i;
            x0 =[SkinThickness,StringerThickness,StringerHeight];
            lb=[1e-3,1e-3,1e-3];
            ub=[0.5,0.5,0.5];

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
