function [buckLength] = FrameAssembly(N,FusL)
    %Takes the fuselage length, and pressure hull length and distributes
    %the number of frames given evenly across the fuselage. It then works
    %out the length of each stringer member, which is later used for the
    %buckling calculations
    
    
    if N == 0 
        framePos = [0, FusL];
    else
        framePos = linspace(0,FusL,N);
        
    end
    buckLength = framePos(2)-framePos(1);
end

    
    