function [stringerPos,b] = StringerDistribution(N,radius)

    
    %Distributes stringer locations equally around the circumference of
    %fuselage returning the coordinates, (0,0) is the center 
    
    % Calculate the angular separation between points
    theta = linspace(sym(pi)/2, 5/2 * sym(pi), N+1); % +1 to close the circle, symbolic Pi used to avoid floating point error

    % Calculate the coordinates of the points
    x = radius * cos(theta(1:end-1));
    y = radius * sin(theta(1:end-1));
    
    % Plot the fuselage
%     t = linspace(0, 2 * sym(pi), 1000);
%     circleX = radius * cos(t);
%     circleY = radius * sin(t);
%     plot(circleX, circleY, 'LineWidth', 2);
%     hold on
%     % Plot the stringers
%     plot(x, y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
% 
%     title('Boom and Skin Idealisation of Fuselage');
%     axis equal;
%     grid on;
    
    %work out the seperation between the points
    b = sym(pi)*radius*2/N;
    
    
    %output setup
    x = [x]';
    y = [y]';
    stringerPos = double([x y]); %converted back to double 
   

end
