function show_model(albedo, height_map,ttl, dtls, fn, visible)
% SHOW_MODEL: display the model with texture
%   albedo: image used as texture for the model
%   height_map: height in z direction, describing the model geometry
%   Spring 2014 CS 543 Assignment 1
% Arun Mallya and Svetlana Lazebnik


% some cosmetic transformations to make 3D model look better
    [hgt, wid] = size(height_map);
    [X,Y] = meshgrid(1:wid, 1:hgt);
    H = height_map;
    A = albedo;
    hFig = figure('Name', ttl, 'visible', visible);
    % H = rot90(fliplr(height_map), 2);
    % A = rot90(fliplr(albedo), 2);
    axis ij;
    
    mesh(X, Y, H, A);
    % axis equal;

    xlabel('X')
    ylabel('Y')
    zlabel('Z (Surface Height)')
    set(gca, 'YDir', 'reverse')
    % mesh(H, X, Y, A);
    % axis equal;
    % xlabel('Z')
    % ylabel('X')
    % zlabel('Y')
    ttl = {ttl; dtls }; 
    title(ttl, 'Interpreter', 'latex');
    view(-60,20)
    colormap(gray)
    colorbar
    % set(gca, 'XDir', 'reverse')
    % set(gca, 'XTick', []);
    % set(gca, 'YTick', []);
    % set(gca, 'ZTick', []);
    saveas(gca,fn,'png');
    savefig(fn);
%     fprintf('-- Save Show Model to : %s \n',fn)


end

