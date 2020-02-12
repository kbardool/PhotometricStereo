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

image_dir_list = {
% './photometrics_images/SG5/SphereGray2/',
% './photometrics_images/SG5/SphereGray2A/',
% './photometrics_images/SG5/SphereGray3/',
% './photometrics_images/SG5/SphereGray4/',
% './photometrics_images/SG5/SphereGray5/',

'./photometrics_images/SG25/SphereGray3/'
'./photometrics_images/SG25/SphereGray6/'
'./photometrics_images/SG25/SphereGray9/'
'./photometrics_images/SG25/SphereGray12/'
'./photometrics_images/SG25/SphereGray15/'
'./photometrics_images/SG25/SphereGray18/'
'./photometrics_images/SG25/SphereGray21/'
'./photometrics_images/SG25/SphereGray24/'
'./photometrics_images/SG25/SphereGray25/'
};
% Z_heights_list = [0.25, 0.50, 0.75, 1.00];
Z_heights_list = [0.50];
shadow_trick = false;
use_linsolve = false;
visible      = 'off';
visualize    = true;
base         = './R25';
for idx =1:length(image_dir_list)
    disp('  ')
    img_dir = image_dir_list{idx};
    for Z_dist = Z_heights_list
        disp(' ');
        disp('--------------------------------------------------------------');
        fprintf('z height: %3.2f filename: %s \n' ,Z_dist, img_dir);
        disp('--------------------------------------------------------------');
        disp(' ');
        disp('Loading images...')
        [image_stack, scriptV, V, normV] = load_syn_images(img_dir, '*.png',1 ,Z_dist);
        [~, ~] = process_image_stack(image_stack, scriptV, Z_dist, shadow_trick, use_linsolve, visible, visualize, base)
        end
    end
disp(' Processing finished');


%%         

disp('Part 1: Photometric Stereo')
disp('Loading images...')
% image_dir = './photometrics_images/MonkeyGray/';   % TODO: get the path of the script
% image_dir = './photometrics_images/SphereGray2/';
% image_dir = './photometrics_images/SphereGray2A/';
% image_dir = './photometrics_images/SphereGray4/';
image_dir = './photometrics_images/SG5/SphereGray5/';  
% image_dir = './photometrics_images/SphereGray9/';
% image_dir = './photometrics_images/SphereGray13/';
% image_dir = './photometrics_images/SphereGray24/';
% image_dir = './photometrics_images/SphereGray25/'
% image_ext    = '*.png';
Z_dist       = 0.50;
shadow_trick = true;
use_linsolve = false;
visible = 'off';

[image_stack, scriptV, V, normV] = load_syn_images(image_dir, '*.png',1 ,Z_dist);

%%
disp('Computing surface albedo and normal map...')
[albedo, normals, surface] = estimate_alb_nrm(image_stack, scriptV, shadow_trick, use_linsolve);
  
%%
%     [h, w, n] = size(image_stack);

Z_diststr = replace(sprintf('%3.2f',Z_dist), ".","");
ttlImages= size(image_stack,3);
dtls = strcat('Num Images: \vspace{2mm}', mat2str(ttlImages), '\hspace{2mm} Z: ', mat2str(Z_dist), ...
'\hspace{4mm} Shadow Trick: \hspace{2mm}', mat2str(shadow_trick));
if shadow_trick
    pfx = 'WST_';
else
    pfx = 'NST_';
end


%%
% [hm_col, hm_row, hm_avg, SE] = process_normals(albedo, normals);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
 
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);


threshold = 0.0005;
fprintf('\n Number of outliers (Squared Error > %f) : %d\n\n', threshold, sum(sum(SE > threshold, 'all')));
SE(SE <= threshold) = NaN; % for good visualization



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
% disp('Construct surface')
% path_type = 'row';
% height_map_row = construct_surface( p, q, path_type );
% 
% path_type = 'column';
% height_map_col = construct_surface( p, q, path_type );
% 
% path_type = 'average';
% height_map_avg = construct_surface( p, q, path_type );


%% Display
    visible = 'on';
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

    %%--------------------------------------------------------------
    %%% 2D Albedo
    %%--------------------------------------------------------------
    f = figure('Name', '1- Albedo 2D','visible',visible);
    imshow(albedo2);
    ttl = {'Albedo ( pixels w/ albedo $>$ 1 set to zero)'; dtls }; 
    title(ttl, 'Interpreter', 'latex');
    colorbar;
%     fn = strcat(base,'/_Albedo2D/', pfx, 'Albedo2D_',mat2str(ttlImages),'_Z',Z_diststr );
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Adebo 2D to : %s \n',fn)


    %%--------------------------------------------------------------
    %%% Surface 
    %%--------------------------------------------------------------
    figure('Name', '2- Surface using A (Non-normalized Albedo)','visible',visible)
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

    %%--------------------------------------------------------------
    %%% Surface from Normals  
    %%--------------------------------------------------------------
    figure('Name', '3- Surface from normals ','visible',visible);
    surf(XX,YY,Z, 'FaceColor', 'interp');
    axis ij;
    ttl = {"Surface $ N = \frac{g}{\mid g\mid}$ "; dtls }; 
    title(ttl , 'Interpreter', 'latex');
    xlabel("X");
    ylabel("Y");
    zlabel("Z");
    zlim([-0.05,1.25]);
    fn = strcat(base,'/_NormalsSurface/', pfx, 'SurfaceNormals_',mat2str(ttlImages),'_Z', Z_diststr);
    saveas(gca,fn,'png');
    savefig(fn);
    fprintf('-- Save Surface from Normals to : %s \n',fn)

    %%--------------------------------------------------------------
    %%% Histogram 
    %%--------------------------------------------------------------
    figure('Name', '4- Albedo Histogram','visible',visible);
    histogram(albedo);
    ttl = {"Albedo Histogram "; dtls }; 
    title(ttl , 'Interpreter', 'latex');
    xlabel("Norm g");
    ylabel("count");
    fn = strcat(base,'/_AlbedoHistograms/', pfx, 'AlbedoHistogram_',mat2str(ttlImages),'_Z', Z_diststr );
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Albedo Histogram to : %s \n',fn)
    
    %%--------------------------------------------------------------
    %%% Surface from Normals 
    %%--------------------------------------------------------------
    figure('Name', '5 - Surface Normals','visible',visible)
    surfnorm(XX,YY,Z, 'FaceAlpha',0.3, 'EdgeColor', 'none');
    ttl = {"Surface $ N = \frac{g}{\mid g\mid}$ "; dtls }; 
    title(ttl, 'Interpreter', 'latex')
    xlabel("X");
    ylabel("Y");
    zlabel("Z");
    zlim([-0.05,1.2]);
    fn = strcat(base,'/_Normals/', pfx, 'Nrmls_',mat2str(ttlImages),'_Z', Z_diststr);
%     saveas(gca,fn,'png');
%     savefig(fn);
%     fprintf('-- Save Surface Normals to : %s \n',fn)
    visible = 'off';
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

visible = 'on';
%%
fn = strcat('./_ShowResults/', pfx, 'Results_',mat2str(ttlImages),'_Z', Z_diststr);
show_results(albedo, normals, SE, dtls, fn, visible);

fn = strcat('./_ShowModel/', pfx, 'ModelRow_',mat2str(ttlImages),'_Z', Z_diststr);
show_model(albedo, hm_row ,"Height Map Using Row Path", dtls, fn, visible);

fn = strcat('./_ShowModel/', pfx, 'ModelCol_',mat2str(ttlImages),'_Z', Z_diststr);
show_model(albedo, hm_col ,"Height Map Using Column Path", dtls, fn, visible);

fn = strcat('./_ShowModel/', pfx, 'ModelAvg_',mat2str(ttlImages),'_Z', Z_diststr);
show_model(albedo, hm_avg ,"Height Map using Average Path", dtls, fn, visible);

%%
fn = strcat('./_HeightMaps/', pfx, 'RHM_',mat2str(ttlImages),'_Z', Z_diststr);
show_height_map(hm_row, "Integration using row",20, dtls, fn, visible);

fn = strcat('./_HeightMaps/', pfx, 'RNM_',mat2str(ttlImages),'_Z', Z_diststr);
show_height_normals(hm_row, "Integration using row",20, dtls, fn, visible );

%%
fn = strcat('./_HeightMaps/', pfx, 'CHM_',mat2str(ttlImages),'_Z', Z_diststr);
show_height_map(hm_col, ' Integration using column path', 20, dtls, fn, visible);

fn = strcat('./_HeightMaps/', pfx, 'CNM_',mat2str(ttlImages),'_Z', Z_diststr);
show_height_normals(hm_col, "Integration using column path",20, dtls, fn, visible);

%%
fn = strcat('./_HeightMaps/', pfx, 'AHM_',mat2str(ttlImages),'_Z', Z_diststr, visible);
show_height_map(hm_avg, "Integration using average",20, dtls, fn, visible);

fn = strcat('./_HeightMaps/', pfx, 'ANM_',mat2str(ttlImages),'_Z', Z_diststr);
show_height_normals(hm_avg, "Intergration using average",20, dtls, fn, visible);

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
height_map_row = construct_surface( p, q, path_type );

path_type = 'column';
height_map_col = construct_surface( p, q, path_type );

path_type = 'average';
height_map_avg = construct_surface( p, q, path_type );

%%
show_results(albedo, normals, SE);
show_model(albedo, height_map_avg);
% figure('Name', '1- Surface using normals')
% show_all_three(height_map_row, height_map_col,height_map_avg);
%%
show_height_map(height_map_row, "Integration using row",20, dtls);
show_height_normals(height_map_row, "Integration using row",20);
%%
show_height_map(height_map_col, ' Integration using column paths', 20);
show_height_normals(height_map_col, "Integration using column path",20);

%%
show_height_map(height_map_avg, "Integration using average",20);
show_height_normals(height_map_avg, "Intergration using average",20);

