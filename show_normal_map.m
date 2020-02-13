function show_normal_map(  normals, shadow_trick ,dtls, fn, visible)
%SHOW_RESULTS display albedo, normal and computational errors

    hFig = figure('visible', visible);
    minN = min(min(normals, [], 1), [], 2);
    maxN = max(max(normals, [], 1), [], 2);
    normal_img = (normals - minN) ./ (maxN - minN);
    imshow(normal_img);  
    axis ij;
    ttl =  'Normal Map ';
%     ttl = strcat(ttl, ' \hspace{2mm}  Count:   ', mat2str(sum(SE > threshold, 'all')), '\vspace{2mm}');
    ttl = {ttl; dtls}; 
    title(ttl, 'Interpreter', 'latex');
    set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
    saveas(gca,fn,'png');
    savefig(fn);    
end    

