function show_height_normals(hm, ttl,  step, dtls, fn, visible)

    if nargin < 3
        step = 5;
    end
%     fprintf(' show height normals - step: %d \n', step)
    [height, width]=size(hm);
    rows = 1:step:height;
    cols = 1:step:width;

    [XX, YY] = meshgrid(rows, cols);
    Z = hm(rows, cols);

    hFig = figure('Name', ttl, 'visible', visible);
    surf( Z, 'FaceColor', 'interp','FaceAlpha',0.7);
    hold on
    [Nx,Ny,Nz] = surfnorm(hm);
    U = Nx(rows,cols);
    V = Ny(rows,cols);
    W = Nz(rows,cols);
    quiver3(Z ,U,V,W, 'Color', 'r');

    % quiver3(XX, YY, hm(rows,cols) ,U,V,W);
    % quiver3(XXmax(rows,cols), YYmax(rows, cols),hm(rows,cols) ,Nx(rows,cols),Ny(rows,cols),Nz(rows,cols), 'Color', 'r');
    % surf(XX,YY,height_map(rows,cols), 'FaceColor', 'interp')
    axis ij;
    ttl = {ttl; dtls }; 
    title(ttl, 'Interpreter', 'latex');
    xlabel(' X');
    ylabel(' Y');
    zlabel(' Z');
    view(-60,20);
    colorbar;
    hold off;

    %--------------------------------------------
    % rows = 1:step:512;
    % cols = 1:step:512;
    % 
    % [XX, YY] = meshgrid(rows, cols);
    % Z = height_map(rows, cols);
    % 
    % % [hgt, wid] = size(height_map);
    % % [XX,YY] = meshgrid(1:wid, 1:hgt);
    % % ax = gca;
    % 
    % figure('Name', title);
    % ax = gca
    % surf(XX,YY,height_map(rows,cols), 'FaceColor', 'interp','FaceAlpha',0.2)
    % hold on
    % [Nx,Ny,Nz] = surfnorm(height_map);
    % U = Nx(rows,cols);
    % V = Ny(rows,cols);
    % W = Nz(rows,cols);
    % quiver3(Z,U,V,W);
    % % surf(XX,YY,height_map(rows,cols), 'FaceColor', 'interp')
    % axis ij;
    % title(title)
    % xlabel(' X');
    % ylabel(' Y');
    % zlabel(' Z');
    % colorbar
    % hold off
    set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
    saveas(gca,fn,'png');
    savefig(fn);
%     fprintf('-- Save Height/Normals Map to : %s \n',fn)    
end