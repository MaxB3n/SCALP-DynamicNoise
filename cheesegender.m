% Define the colors for the corners
color_top_left = [0, 0, 1]; % Blue
color_top_right = [1, 1, 0]; % Yellow
color_bottom_left = [0.5, 0.5, 0.5]; % Gray
color_bottom_right = [1, 0.1, 0.6]; % Pink

% %% legend 
% lgd = legend('agender','femme','masc','genderqueer', 'hide')

% Create a grid of points
n = 500; % Number of points along each axis
x = linspace(0, 1, n); % X-axis from 0 to 1
y = linspace(0, 1, n); % Y-axis from 0 to 1
[X, Y] = meshgrid(x, y);

% Interpolate colors
% Create a color matrix
colors = zeros(n, n, 3);

% Interpolate along the top edge (blue to yellow)
for i = 1:n
    top_edge_color = interp1([0 1], [color_top_left; color_top_right], x(i), 'linear');
    bottom_edge_color = interp1([0 1], [color_bottom_left; color_bottom_right], x(i), 'linear');
    for j = 1:n
        colors(j, i, :) = interp1([0 1], [top_edge_color; bottom_edge_color], y(j), 'linear');
    end
end

hold on 

% Add text annotations
text_positions = [0.05, 0.95;  % Top-left (mozz) -- agender
                   0.2, 0.8;  % cream cheese
                  0.2, 0.5;  %  havarti
                  0.4, 0.7;  % ricotta
                   0.95, 0.95;  % Top-right (brie) -- femme 
                   0.75, 0.8; % marscapone
                   0.8, 0.5;  % feta
                   0.5, 0.5;  % parmesan
                   0.9, 0.7;  % gruyere
                   0.1, 0.05;  % Bottom-left (gorgonzola) -- masc
                   0.2, 0.3;  % gouda
                   0.1, 0.2;  % american
                   0.95, 0.05; % Bottom-right (cheddar) -- genderqueer
                   0.8, 0.2; % swiss
                   0.7, 0.1]; % cottage cheese
                    
               
text_labels = {'mozz', 'cream chz', 'havarti', 'ricotta', 'brie', 'marscapone', 'feta', 'parmesan', 'gruyere', 'gorgonzola', 'gouda', 'american', 'cheddar', 'swiss', 'cottage chz'};

% Plot the text at specified positions
for k = 1:length(text_labels)
    text(text_positions(k, 1), text_positions(k, 2), text_labels{k}, ...
         Color='k', HorizontalAlignment='center', VerticalAlignment='middle', FontSize=8);
end

hold on

% Plot the result
figure;
image(x, y, colors);
axis xy; % Flip the y-axis to match the coordinate system
axis off; % Turn off the axis
title('Cheese Type vs Gender Identity Spectrum',FontSize=16);
ylabel('               Agender',FontSize=12);
xlabel('Masc          Genderqueer',FontSize=12);


