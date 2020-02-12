function show_height_map(height_map, ttl,  step, dtls, fn, visible)

    if nargin == 2
        step = 5;
    end
    [height, width]=size(height_map);
    rows = 1:step:height;
    cols = 1:step:width;

    [XX, YY] = meshgrid(rows, cols);
    % [hgt, wid] = size(height_map);
    % [XX,YY] = meshgrid(1:wid, 1:hgt);
    % ax = gca;

    figure('Name', ttl, 'visible', visible);
    surf(XX,YY,height_map(rows,cols), 'FaceColor', 'interp','FaceAlpha',0.7  )
    axis ij;
    ttl = {ttl; dtls }; 
    title(ttl, 'Interpreter', 'latex');
    xlabel("X");
    ylabel("Y");
    zlabel("Z");
    colorbar;
    
    saveas(gca,fn,'png');
    savefig(fn);
    fprintf('-- Save Height Map to : %s \n',fn)  
end