close all
clc
clear all
%%
% obtain many images in a fixed view under different illumination
disp('Part 1: Photometric Stereo')
disp('Loading images...')
% image_dir = './photometrics_images/MonkeyGray/';   % TODO: get the path of the script
% image_dir = './photometrics_images/SG5/SphereGray2/';
% image_dir = './photometrics_images/SG5/SphereGray2A/';
% image_dir = './photometrics_images/SG5/SphereGray4/';
% image_dir = './photometrics_images/SG5/SphereGray5/';  
% image_dir = './photometrics_images/SG25/SphereGray9/';
% image_dir = './photometrics_images/SG25/SphereGray13/';
% image_dir = './photometrics_images/SG25/SphereGray24/';
% image_dir = './photometrics_images/SG25/SphereGray25/'
%image_ext = '*.png';

Z_heights_list = [0.25, 0.50, 0.75, 1.00];
%%
close all
clear all

% image_dir_list = {
% './photometrics_images/SG5/SphereGray2/',
% './photometrics_images/SG5/SphereGray2A/',
% './photometrics_images/SG5/SphereGray3/',
% './photometrics_images/SG5/SphereGray4/',
% './photometrics_images/SG5/SphereGray5/',
%%

% base           = './R25D';
% image_dir_list = {
% './photometrics_images/SG25D/m4'
% './photometrics_images/SG25D/m9'
% };

%%-------------------------------------------------------------
%%% Monkey Gray 
%%-------------------------------------------------------------
% base           = './MG';
% image_dir_list = {
% './photometrics_images/MG/m001/'
% './photometrics_images/MG/m009/'
% './photometrics_images/MG/m017/'
% './photometrics_images/MG/m025/'
% './photometrics_images/MG/m033/'
% './photometrics_images/MG/m041/'
% './photometrics_images/MG/m048/'
% './photometrics_images/MG/m049/'
% './photometrics_images/MG/m080/'
% './photometrics_images/MG/m081/'
% './photometrics_images/MG/m120/'
% './photometrics_images/MG/m121/'
% './photometrics_images/MG/m040/'
% './photometrics_images/MG/m032/'
% './photometrics_images/MG/m024/'
% './photometrics_images/MG/m016/'
% './photometrics_images/MG/m008/'
% % };

 %%         

% disp('Part 1: Photometric Stereo')
% disp('Loading images...')
% image_dir = './photometrics_images/MonkeyGray/';   % TODO: get the path of the script
% image_dir = './photometrics_images/SphereGray2/';
% image_dir = './photometrics_images/SphereGray2A/';
% image_dir = './photometrics_images/SphereGray4/';
% image_dir = './photometrics_images/SG5/SphereGray5/';  
% image_dir = './photometrics_images/SphereGray9/';
% image_dir = './photometrics_images/SphereGray13/';
% image_dir = './photometrics_images/SphereGray24/';
% image_dir = './photometrics_images/SphereGray25/'
% image_ext    = '*.png';
%%
%%-------------------------------------------------------------
%%% Monkey Gray 
%%-------------------------------------------------------------
base           = './MG';

% './photometrics_images/MG/m001/'
% './photometrics_images/MG/m009/'
% './photometrics_images/MG/m017/'
% './photometrics_images/MG/m025/'
% './photometrics_images/MG/m033/'
% './photometrics_images/MG/m041/'
% './photometrics_images/MG/m048/'
% './photometrics_images/MG/m049/'
% './photometrics_images/MG/m080/'
% './photometrics_images/MG/m081/'
% './photometrics_images/MG/m120/'
% './photometrics_images/MG/m121/'
% './photometrics_images/MG/m040/'
% './photometrics_images/MG/m032/'
image_dir = ....
'./photometrics_images/MG/m008/'
% './photometrics_images/MG/m016/'
% './photometrics_images/MG/m008/'
% % };


%%
base      = './MG';
image_dir = './photometrics_images/MG/m008/';
Z_dist       = 0.50;
shadow_trick = true;
use_linsolve = false;
display_plots= 'off';
save_plots    = true;

[image_stack, scriptV, V, normV] = load_syn_images(image_dir, '*.png',1 ,Z_dist);

disp('Computing surface albedo and normal map...')
[albedo, normals, surface] = estimate_alb_nrm(image_stack, scriptV, shadow_trick, use_linsolve);
  

ttlImages = size(image_stack,3);
ttlImages_str = sprintf('%03d',ttlImages); 
Z_dist_str = replace(sprintf('%3.2f',Z_dist), ".","");
suffix = strcat( ttlImages_str,'_Z', Z_dist_str);

dtls = strcat('Num Images: \hspace{2pt}', mat2str(ttlImages), '\hspace{2mm} Z: \hspace{2pt}', mat2str(Z_dist), ...
'\hspace{4mm} Shadow Trick: \hspace{2pt}', mat2str(shadow_trick));

if shadow_trick
    prefix = 'WST_';
else
    prefix = 'NST_';
end

disp(prefix)
disp(dtls)

%%

    fn = strcat(base,'/_ShowNormMap/', prefix, 'NM_', suffix);
    show_normal_map(  normals, shadow_trick , dtls, fn, true)


%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
% [hm_col, hm_row, hm_avg, SE] = process_normals(albedo, normals); 
    disp('Integrability checking')
    [p, q, SE] = check_integrability(normals);


    threshold = 0.0005;
    fprintf('\n Number of outliers (Squared Error > %f) : %d\n\n', threshold, sum(SE > threshold, 'all'));
    SE(SE <= threshold) = NaN; % for good visualization

%%
    visible = display_plots;
    visible = true;
    fn = strcat(base,'/_ShowResults/', prefix, '2ndDeriv_', suffix);
    show_integrability( SE, threshold, shadow_trick, dtls, fn, visible);

%%
stepsize = 20;
rows = 1:stepsize:512;
cols = 1:stepsize:512;
[XX, YY] = meshgrid(rows, cols);
size(YY)
figure ('Name', 'P/Q','NumberTitle','off'),
subplot (1,4, [1 2]), surf(XX,YY,p(rows,cols)); title ('p');
subplot (1,4, [3 4]), contour3(XX,YY,p(rows,cols),10); title ('p');

%% % compute the surface height
disp('Construct surface')
path_type = 'row';
hm_row = construct_surface( p, q, path_type );

path_type = 'column';
hm_col = construct_surface( p, q, path_type );

path_type = 'average';
hm_avg = construct_surface( p, q, path_type );


%% Display
    display_plots = 'on';
    stepsize = 10;
    rows = 1:stepsize:512;
    cols = 1:stepsize:512;
    [XX, YY] = meshgrid(rows, cols);
    ZZ0   = zeros(size(XX));
    ZZ1   = ones(size(XX));
    ZZ512 = zeros(512);
    ZO512 = ones(512);
    X = normals(rows,cols,1);
    Y = normals(rows,cols,2);
    Z = normals(rows,cols,3);
    S = surface(rows,cols,3);
    A = albedo(rows,cols);

    albedo2 = zeros(size(albedo));
    albedo2 = albedo;
    albedo2(albedo2 > 1.0001) = NaN;
    A2 = albedo2(rows,cols);
%%
%%--------------------------------------------------------------
%%% 2D Albedo
%%--------------------------------------------------------------
f = figure('Name', '1- Albedo 2D','visible',display_plots);
imshow(albedo2);
ttl = {'Albedo ( pixels w/ albedo $>$ 1 set to zero)'; dtls }; 
title(ttl, 'Interpreter', 'latex');
colorbar;
%     fn = strcat(base,'/_Albedo2D/', pfx, 'Albedo2D_',mat2str(ttlImages),'_Z',Z_diststr );
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Adebo 2D to : %s \n',fn)

%%
%%--------------------------------------------------------------
%%% 3D Albedo
%%--------------------------------------------------------------
figure('Name', '2- Surface using A (Non-normalized Albedo)','visible',display_plots)
surf(XX,YY, A, 'FaceColor', 'interp')

axis ij;
ttl = {"Aldebo: $\rho(x,y) = \mid g(x,y)\mid$ "; dtls}; 
title(ttl, 'Interpreter', 'latex')
%     zlim([-0.05,1.25]);
xlabel("X");
ylabel("Y");
zlabel("Z");
hold on
surf(XX,YY,ZZ1,'FaceColor','red', 'FaceAlpha','0.6');
hold off
fn = strcat(base,'/_Albedos/', pfx, 'Albedo_',mat2str(ttlImages),'_Z', Z_diststr );
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Albedo plot to : %s \n',fn)
%%
%%--------------------------------------------------------------
%%% Surface from Normals  
%%--------------------------------------------------------------
figure('Name', '3- Surface from normals ','visible',display_plots);
surf(XX,YY,Z, 'FaceColor', 'interp');
axis ij;
ttl = {"Surface $ N = \frac{g}{\mid g\mid}$ "; dtls }; 
title(ttl , 'Interpreter', 'latex');
xlabel("X");
ylabel("Y");
zlabel("Z");
zlim([-0.05,1.25]);
%     fn = strcat(base,'/_NormalsSurface/', pfx, 'SurfaceNormals_',mat2str(ttlImages),'_Z', Z_diststr);
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Surface from Normals to : %s \n',fn)


%%    
%%--------------------------------------------------------------
%%% Surface Normals 
%%--------------------------------------------------------------
figure('Name', '5 - Surface Normals','visible',display_plots)
surfnorm(XX,YY,Z, 'FaceAlpha',0.2, 'EdgeColor', 'none');
ttl = {"Surface $ N = \frac{g}{\mid g\mid}$ "; dtls }; 
title(ttl, 'Interpreter', 'latex')
xlabel("X");
ylabel("Y");
zlabel("Z");
zlim([-0.05,1.2]);
fn = strcat(base,'/_Normals/', pfx, 'Nrmls_',mat2str(ttlImages),'_Z', Z_diststr);
hold on
surf(XX,YY,ZZ0,'FaceColor','red', 'FaceAlpha','0.6');
    hold off
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Surface Normals to : %s \n',fn)
%     visible = 'off';

%%
%%--------------------------------------------------------------
%%% Histogram 
%%--------------------------------------------------------------
figure('Name', '4- Albedo Histogram','visible',display_plots);
histogram(albedo);
ttl = {"Albedo Histogram "; dtls }; 
title(ttl , 'Interpreter', 'latex');
xlabel("Norm g");
ylabel("count");
fn = strcat(base,'/_AlbedoHistograms/', pfx, 'AlbedoHistogram_',mat2str(ttlImages),'_Z', Z_diststr );
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Albedo Histogram to : %s \n',fn)

%%
figure ('Name', 'P','NumberTitle','off'),
subplot (1,4, [1 2]), surf(XX,YY,p(rows,cols)); title ('p = ', 'interpreter', 'latex');
subplot (1,4, [3 4]), contour3(XX,YY,p(rows,cols),10); title ('p');

figure ('Name', 'Q','NumberTitle','off'),
subplot (1,4, [1 2]), surf(XX,YY,q(rows,cols)); title ('q', 'interpreter', 'latex');
subplot (1,4, [3 4]), contour3(XX,YY,q(rows,cols),10); title ('q', 'interpreter', 'latex');
%%

figure ('Name', 'SE','NumberTitle','off'),
subplot (1,4, [1 2]), surf(SE); title ('SE', 'interpreter', 'latex');
subplot (1,4, [3 4]), contour3(SE(rows,cols),10); title ('SE', 'interpreter', 'latex');
%%

display_plots = 'on';
%%
        fn = strcat(base,'/_ShowResults/', prefix, 'Results_', suffix);
        show_results(albedo, normals, SE, dtls, fn, display_plots);
%%
        fn = strcat(base,'/_ShowModel/', prefix, 'Row_', suffix);
        show_model(albedo, hm_row ,"Height Map Using Row Path", dtls, fn, display_plots);
        fn = strcat(base,'/_ShowModel/', prefix, 'Col_', suffix);
        show_model(albedo, hm_col ,"Height Map Using Column Path", dtls, fn, display_plots);
        fn = strcat(base,'/_ShowModel/', prefix, 'Avg_', suffix);
        show_model(albedo, hm_avg ,"Height Map using Average Path", dtls, fn, display_plots);
%%
        stepsize = 10
        fn = strcat(base,'/_ShowHeightMaps/', prefix, 'Hgt_Row_', suffix);
        show_height_map(hm_row, "Integration using row", stepsize, dtls, fn, display_plots);
        fn = strcat(base,'/_ShowHeightMaps/', prefix, 'Hgt_Col_', suffix);
        show_height_map(hm_col, ' Integration using column path', stepsize, dtls, fn, display_plots);
        fn = strcat(base,'/_ShowHeightMaps/', prefix, 'Hgt_Avg_', suffix);
        show_height_map(hm_avg, "Integration using average", stepsize, dtls, fn, display_plots);
%%        
        fn = strcat(base,'/_ShowHeightNormals/', prefix, 'Nrml_Row_', suffix);
        show_height_normals(hm_row, "Integration using row", stepsize, dtls, fn, display_plots );
        fn = strcat(base,'/_ShowHeightNormals/', prefix, 'Nrml_Col_', suffix);
        show_height_normals(hm_col, "Integration using column path",stepsize, dtls, fn, display_plots);
        fn = strcat(base,'/_ShowHeightNormals/', prefix, 'Nrml_Avg_', suffix);
        show_height_normals(hm_avg, "Intergration using average", stepsize, dtls, fn, display_plots);
%%

 




%% Face






%%
[image_stack, scriptV] = load_face_images('./photometrics_images/yaleB02/');
%%
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);
%%
% imwrite(normals, 'Normal.png');
% imwrite(albedo, 'Albedo.png');


figure ('Name', '2D Images under different light directions plus Normal and Albedo','NumberTitle','off'),
subplot (1,4, [1 2]), imshow(normals); title ('Normal');
subplot (1,4, [3 4]), imshow(albedo); title('Albedo');

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);


%%
threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
disp('Construct Surface')
% height_map = construct_surface( p, q );
disp('Construct surface')
path_type = 'row';
hm_row = construct_surface( p, q, path_type );

path_type = 'column';
hm_col = construct_surface( p, q, path_type );

path_type = 'average';
hm_avg = construct_surface( p, q, path_type );

%%
show_results(albedo, normals, SE);
show_model(albedo, hm_avg);
% figure('Name', '1- Surface using normals')
% show_all_three(height_map_row, height_map_col,height_map_avg);
%%
show_height_map(hm_row, "Integration using row",20, dtls);
show_height_normals(hm_row, "Integration using row",20);
%%
show_height_map(hm_col, ' Integration using column paths', 20);
show_height_normals(hm_col, "Integration using column path",20);

%%
show_height_map(hm_avg, "Integration using average",20);
show_height_normals(hm_avg, "Intergration using average",20);

