function [hm_col, hm_row, hm_avg, SE] = process_normals(albedo, normals, ttlImages, Z_dist, shadow_trick,  visible, visualize, base)
     
    fprintf('\nIntegrability checking and surface construction \n');
    tic
    [p, q, SE] = check_integrability(normals);

    threshold = 0.0005;
    fprintf('\n Number of outliers (Squared Error > %f) : %d\n\n', threshold, sum(sum(SE > threshold, 'all')));
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
        
        Z_diststr = replace(sprintf('%3.2f',Z_dist), ".","");
        dtls = strcat('Num Images: \vspace{2mm}', mat2str(ttlImages), '\hspace{2mm} Z: ', mat2str(Z_dist), ...
        '\hspace{4mm} Shadow Trick: \hspace{2mm}', mat2str(shadow_trick));

        if shadow_trick
            pfx = 'WST_';
        else
            pfx = 'NST_';
        end
        
        fn = strcat(base,'/_ShowResults/', pfx, 'Results_',mat2str(ttlImages),'_Z', Z_diststr);
        show_results(albedo, normals, SE, dtls, fn, visible);

        fn = strcat(base,'/_ShowModel/', pfx, 'Row_',mat2str(ttlImages),'_Z', Z_diststr);
        show_model(albedo, hm_row ,"Height Map Using Row Path", dtls, fn, visible);
        fn = strcat(base,'/_ShowModel/', pfx, 'Col_',mat2str(ttlImages),'_Z', Z_diststr);
        show_model(albedo, hm_col ,"Height Map Using Column Path", dtls, fn, visible);
        fn = strcat(base,'/_ShowModel/', pfx, 'Avg_',mat2str(ttlImages),'_Z', Z_diststr);
        show_model(albedo, hm_avg ,"Height Map using Average Path", dtls, fn, visible);

        fn = strcat(base,'/_ShowHeightMaps/', pfx, 'Hgt_Row_',mat2str(ttlImages),'_Z', Z_diststr);
        show_height_map(hm_row, "Integration using row",20, dtls, fn, visible);
        fn = strcat(base,'/_ShowHeightMaps/', pfx, 'Hgt_Col_',mat2str(ttlImages),'_Z', Z_diststr);
        show_height_map(hm_col, ' Integration using column path', 20, dtls, fn, visible);
        fn = strcat(base,'/_ShowHeightMaps/', pfx, 'Hgt_Avg_',mat2str(ttlImages),'_Z', Z_diststr);
        show_height_map(hm_avg, "Integration using average",20, dtls, fn, visible);
        
        fn = strcat(base,'/_ShowHeightNormals/', pfx, 'Nrml_Row_',mat2str(ttlImages),'_Z', Z_diststr);
        show_height_normals(hm_row, "Integration using row",20, dtls, fn, visible );
        fn = strcat(base,'/_ShowHeightNormals/', pfx, 'Nrml_Col_',mat2str(ttlImages),'_Z', Z_diststr);
        show_height_normals(hm_col, "Integration using column path",20, dtls, fn, visible);
        fn = strcat(base,'/_ShowHeightNormals/', pfx, 'Nrml_Avg_',mat2str(ttlImages),'_Z', Z_diststr);
        show_height_normals(hm_avg, "Intergration using average",20, dtls, fn, visible);
    end
end
