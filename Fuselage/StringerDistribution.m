function [stringerPos,b] = StringerDistribution(N,radius)

    
    %Distributes stringer locations equally around the circumference of
    %fuselage returning the coordinates, (0,0) is the center 
    
    % Calculate the angular separation between points
    theta = linspace(90, 5/2 * 180, N+1); % +1 to close the circle
    
   

    % Calculate the coordinates of the points, there will be a floating
    % point error, this might be fixed later
 
    y = radius * sind(theta(1:end-1));
    
    
    % Plot the fuselage, this is for validation more than anything
    x = radius*cosd(theta(1:end-1));
    t = linspace(0, 2 * pi, 1000);
    circleX = radius * cos(t);
    circleY = radius * sin(t);
%     plot(circleX, circleY, 'LineWidth', 2);
%     hold on
%     % Plot the stringers
%     plot(x, y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'b');
% 
%     title('Boom and Skin Idealisation of Fuselage');
%     axis equal;
%     grid on;
    
    %work out the seperation between the points, arc length
    b = pi*radius*2/N;
    
    
    %output setup
    y = [y]';
    stringerPos = double(y); %converted back to double 
    
    

end
