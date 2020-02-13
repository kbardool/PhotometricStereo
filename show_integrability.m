function show_integrability(  SE, threshold, shadow_trick ,dtls, fn, visible)
%SHOW_RESULTS display albedo, normal and computational errors

    hFig = figure('visible', visible);
    
    [h, w, ~] = size(SE);
    [X, Y] = meshgrid(1:w, 1:h);
    surf(X, Y, SE(:,:,1)) ; % gradient(SE));
    axis ij;
    ttl = strcat('Integrability check: $(\frac{dp}{dy} - \frac{dq}{dx})^2 > $ ', mat2str(threshold));
    ttl = strcat(ttl, ' \hspace{2mm}  Count:   ', mat2str(sum(SE > threshold, 'all')), '\vspace{2mm}');
    ttl = {ttl; dtls}; 
    title(ttl, 'Interpreter', 'latex');
    xlabel("X");
    ylabel("Y");
    zlabel("Z");
    if shadow_trick
        zlim([ 0.00,1.200]);
    else
        zlim([ 0.00,5.200]);
    end

    set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
    saveas(gca,fn,'png');
    savefig(fn);    
end