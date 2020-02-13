function show_all_three(height_map_row,height_map_col, height_map_avg , step)

if nargin == 3
    step = 5;
end
rows = 1:step:512;
cols = 1:step:512;

[XX, YY] = meshgrid(rows, cols);
ttl = 'Show all three';
% plot the results
figure('Name', ttl, 'visible', visible);
subplot(1, 3, 1);

% [hgt, wid] = size(height_map);
% [XX,YY] = meshgrid(1:wid, 1:hgt);
% ax = gca;

title('Integration using row');
surf(XX,YY,height_map_row(rows,cols), 'FaceColor', 'interp')
axis ij;
xlabel(' X');
ylabel(' Y');
zlabel(' Z');

subplot(1, 3, 2);

% [hgt, wid] = size(height_map);
% [XX,YY] = meshgrid(1:wid, 1:hgt);
% ax = gca;

title('Integration using column');
surf(XX,YY,height_map_col(rows,cols), 'FaceColor', 'interp')
axis ij;
xlabel(' X');
ylabel(' Y');
zlabel(' Z');

subplot(1, 3, 3);

% [hgt, wid] = size(height_map);
% [XX,YY] = meshgrid(1:wid, 1:hgt);
% ax = gca;

title('Integration using averge');
surf(XX,YY,height_map_avg(rows,cols), 'FaceColor', 'interp')
axis ij;
xlabel(' X');
ylabel(' Y');
zlabel(' Z');

end
