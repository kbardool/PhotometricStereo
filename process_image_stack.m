function [albedo, normals]= process_image_stack(image_stack, scriptV, use_linsolve, Z_dist, shadow_trick, display_plots, save_plots, base)

    disp('Computing surface albedo and normal map...');
    [albedo, normals, surface] = estimate_alb_nrm(image_stack, scriptV, shadow_trick, use_linsolve);
 
    %%--------------------------------------------------------------------------------------------
    %%- Visualizations 
    %%--------------------------------------------------------------------------------------------
    if save_plots
        disp('Write Visualizations  ');
        ttlImages = size(image_stack,3);        
        dtls = strcat('Num Images: \vspace{2mm}', mat2str(ttlImages), '\hspace{2mm} Z: ', mat2str(Z_dist), ...
        '\hspace{4mm} Shadow Trick: \hspace{2mm}', mat2str(shadow_trick));
                
        if shadow_trick
            prefix = 'WST_';
        else
            prefix = 'NST_';
        end
        
        Z_dist_str = replace(sprintf('%3.2f',Z_dist), ".","");
        ttlImages_str = sprintf('%03d',ttlImages);        
        suffix = strcat( ttlImages_str,'_Z', Z_dist_str);

        
        stepsize = 20;
        rows = 1:stepsize:512;
        cols = 1:stepsize:512;
        [XX, YY] = meshgrid(rows, cols);
        ZZ0   = zeros(size(XX));
        ZZ1   = ones(size(XX));
        ZZ512 = zeros(512);
        X = normals(rows,cols,1);
        Y = normals(rows,cols,2);
        Z = normals(rows,cols,3);
        S = surface(rows,cols,3);
        A = albedo(rows,cols);

        albedo2 = zeros(size(albedo));
        albedo2 = albedo;
        albedo2(albedo2 > 1.0001) = NaN;
        A2 = albedo2(rows,cols);

        %%--
        hFig = figure('Name', '1- Albedo 2D','visible',display_plots);
        imshow(albedo2);
        ttl = {'Albedo ( pixels w/ albedo $>$ 1 set to zero)'; dtls }; 
        title(ttl, 'Interpreter', 'latex');
        colorbar;
        fn = strcat(base,'/_Albedo2D/', prefix, 'Albedo2D_', suffix );
        set(hFig, 'CreateFcn', 'set(gcbo,''display_plots'',''on'')'); 
        saveas(gca,fn,'png');
        savefig(fn);
%         fprintf('-- Save Adebo 2D to : %s \n',fn)

        %%--
        hFig = figure('Name', '2- Surface using A (Non-normalized Albedo)','visible',display_plots);
        surf(XX,YY, A, 'FaceColor', 'interp')
        axis ij;
        ttl = {"Aldebo: $\rho(x,y) = \mid g(x,y)\mid$ "; dtls}; 
        title(ttl, 'Interpreter', 'latex')
        zlim([-0.05,1.75]);
        xlabel("X");
        ylabel("Y");
        zlabel("Z");
        hold on
        surf(XX,YY,ZZ1,'FaceColor','red', 'FaceAlpha','0.6');
        hold off
        fn = strcat(base,'/_Albedos/', prefix, 'Albedo_', suffix );
        set(hFig, 'CreateFcn', 'set(gcbo,''display_plots'',''on'')'); 
        saveas(gca,fn,'png');
        savefig(fn);
%         fprintf('-- Save Albedo plot to : %s \n',fn)

        %%--
        hFig = figure('Name', '3- Surface from normals ','visible',display_plots);
        surf(XX,YY,Z, 'FaceColor', 'interp');
        axis ij;
        ttl = {"Surface $ N = \frac{g}{\mid g\mid}$ "; dtls }; 
        title(ttl , 'Interpreter', 'latex');
        xlabel("X");
        ylabel("Y");
        zlabel("Z");
        zlim([-0.05,1.75]);
        fn = strcat(base,'/_NormalsSurface/', prefix, 'SurfaceNormals_', suffix);
        set(hFig, 'CreateFcn', 'set(gcbo,''display_plots'',''on'')'); 
        saveas(gca,fn,'png');
        savefig(fn);
%         fprintf('-- Save Surface from Normals to : %s \n',fn)

        %%--
        hFig = figure('Name', '5 - Surface Normals','visible',display_plots);
        surfnorm(XX,YY,Z, 'FaceAlpha',0.3, 'EdgeColor', 'none');
        ttl = {"Surface $ N = \frac{g}{\mid g\mid}$ "; dtls }; 
        title(ttl, 'Interpreter', 'latex')
        xlabel("X");
        ylabel("Y");
        zlabel("Z");
        zlim([0.6,1.2]);
        fn = strcat(base,'/_Normals/', prefix, 'Nrmls_', suffix);
        set(hFig, 'CreateFcn', 'set(gcbo,''display_plots'',''on'')'); 
        saveas(gca,fn,'png');
        savefig(fn);
%         fprintf('-- Save Surface Normals to : %s \n',fn)

        %%--
        hFig = figure('Name', '4- Albedo Histogram','visible',display_plots);
        histogram(albedo);
        ttl = {"Albedo Histogram "; dtls }; 
        title(ttl , 'Interpreter', 'latex');
        xlabel("Norm g");
        ylabel("count");
        fn = strcat(base,'/_AlbedoHistograms/', prefix, 'AlbedoHistogram_', suffix );
        set(hFig, 'CreateFcn', 'set(gcbo,''display_plots'',''on'')'); 
        saveas(gca,fn,'png');
        savefig(fn);
%         fprintf('-- Save Albedo Histogram to : %s \n',fn)


    
    end
    
    %%
    % figure('Name', '2- Surface using S (Non-normalized)')
    % surf(XX,YY,S, 'FaceColor', 'interp')
    % fprintf(' Surface minimum: %f  maximum: %f \n', min(S,[],'all'), max(S,[],'all'));
    % axis ij;
    % ttl = {"Surface $ g(x,y)= \rho(x,y)\cdot N(x,y)$ "; dtls}; 
    % disp(ttl)
    % title(ttl , 'interpreter', 'latex');
    % xlabel("X");
    % ylabel("Y");
    % zlabel("Z");
    %%
    % figure('Name', '3B - Surface using A2 (Non-normalized Albedo)')
    % surf(XX,YY, A2, 'FaceColor', 'interp')
    % fprintf(' Albedo minimum: %f  maximum: %f \n', min(A2,[],'all'), max(A2,[],'all'));
    % axis ij;
    % ttl = {"Aldebo2 :$\rho(x,y) = \mid g(x,y)\mid$ "; dtls}; 
    % title(ttl, 'Interpreter', 'latex')
    % xlabel("X");
    % ylabel("Y");
    % zlabel("Z");
    % hold on
    % surf(XX,YY,ZZ1,'FaceColor','red', 'FaceAlpha','0.8  ');
    % hold off


    %%
    % figure ('Name', '2D Images under different light directions plus Normal and Albedo','NumberTitle','off'),
    % subplot (1,6, [1 2]), imshow(normals); title ('Normal');colorbar;
    % subplot (1,6, [3 4]), imshow(albedo); title('Albedo'); colorbar;
    % subplot (1,6, [5 6]), imshow(albedo2); title('Albedo (> 1 set to zero)'); colorbar;

    %%
    % [Nx,Ny,Nz] = surfnorm(XX,YY,Z);
    % 
    % f = figure('Name', '6 - Quiver Field')
    % ax = gca
    % quiver3(XX,YY,Z,Nx,Ny,Nz);
    % zlim([0, 3]);
    % hold on
    % surf(Z)
    % view(-35,45)
    % % axis([-2 2 -1 1 -.6 .6])
    % hold off
    % % q = quiver3(XX,YY,ZZ,X,Y,Z);
    % % quiver3(X,Y,Z,XX,YY,ZZ) ;
    % % ax.ZLim = [1, 2]
    % % q.XData = 1:21
    % % q.YData = 1:21

end