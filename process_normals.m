function [hm_col, hm_row, hm_avg, SE] = process_normals(albedo, normals, ttlImages, Z_dist, shadow_trick,  display_plots, visualize, base)
     
    fprintf('\nIntegrability checking and surface construction \n');
    tic
    [p, q, SE] = check_integrability(normals);

    threshold = 0.0005;
    fprintf(' Number of outliers ( Error^2 > %.4f) : %d\n\n', threshold,  sum(SE > threshold, 'all'));
    SE(SE <= threshold) = NaN; % for good visualization

    % compute the surface height
    disp('Construct surface')
    path_type = 'row';
    hm_row = construct_surface( p, q, path_type );

    path_type = 'column';
    hm_col = construct_surface( p, q, path_type );

    path_type = 'average';
    hm_avg = construct_surface( p, q, path_type );
    t2 = toc;
    fprintf('Completed in %.5f seconds \n',t2)
    
    %%--------------------------------------------------------------------------------------------
    %%- Final Visualizations 
    %%--------------------------------------------------------------------------------------------    
    if visualize
        disp('Write Visualizations  ');
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
        
        fn = strcat(base,'/_ShowResults/', prefix, '2ndDeriv_', suffix);
        show_integrability( SE, threshold, shadow_trick, dtls, fn, display_plots);
        
        fn = strcat(base,'/_ShowResults/', prefix, 'Results_', suffix);
        show_results(albedo, normals, SE, dtls, fn, display_plots);

        fn = strcat(base,'/_ShowModel/', prefix, 'Row_', suffix);
        show_model(albedo, hm_row ,"Height Map Using Row Path", dtls, fn, display_plots);
        fn = strcat(base,'/_ShowModel/', prefix, 'Col_', suffix);
        show_model(albedo, hm_col ,"Height Map Using Column Path", dtls, fn, display_plots);
        fn = strcat(base,'/_ShowModel/', prefix, 'Avg_', suffix);
        show_model(albedo, hm_avg ,"Height Map using Average Path", dtls, fn, display_plots);

        fn = strcat(base,'/_ShowHeightMaps/', prefix, 'Hgt_Row_', suffix);
        show_height_map(hm_row, "Integration using row",20, dtls, fn, display_plots);
        fn = strcat(base,'/_ShowHeightMaps/', prefix, 'Hgt_Col_', suffix);
        show_height_map(hm_col, ' Integration using column path', 20, dtls, fn, display_plots);
        fn = strcat(base,'/_ShowHeightMaps/', prefix, 'Hgt_Avg_', suffix);
        show_height_map(hm_avg, "Integration using average",20, dtls, fn, display_plots);
        
        fn = strcat(base,'/_ShowHeightNormals/', prefix, 'Nrml_Row_', suffix);
        show_height_normals(hm_row, "Integration using row",20, dtls, fn, display_plots );
        fn = strcat(base,'/_ShowHeightNormals/', prefix, 'Nrml_Col_', suffix);
        show_height_normals(hm_col, "Integration using column path",20, dtls, fn, display_plots);
        fn = strcat(base,'/_ShowHeightNormals/', prefix, 'Nrml_Avg_', suffix);
        show_height_normals(hm_avg, "Intergration using average",20, dtls, fn, display_plots);
    end
end
