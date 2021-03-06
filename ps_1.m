
close all
clc
clear all
%%
% obtain many images in a fixed view under different illumination
% disp('Part 1: Photometric Stereo')
% disp('Loading images...')
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
% Z_heights_list = [0.25, 0.50, 0.75, 1.00];
%%
close all 
clear all



%%-------------------------------------------------------------
%%% Sphere Gray 5
%%-------------------------------------------------------------
% base           = './R5';
% image_dir_list = {
% % './photometrics_images/SG5/SphereGray1/',
% % './photometrics_images/SG5/SphereGray2/',
% % './photometrics_images/SG5/SphereGray2A/',
% % './photometrics_images/SG5/SphereGray3/',
% % './photometrics_images/SG5/SphereGray4/',
% './photometrics_images/SG5/SphereGray5/',
% } ;
% 
%%-------------------------------------------------------------
%%% Sphere Gray 25 
%%-------------------------------------------------------------
% base           = './R25';
% image_dir_list = {
% './photometrics_images/SG25/SphereGray1/'
% './photometrics_images/SG25/SphereGray2/'
% './photometrics_images/SG25/SphereGray3/'
% './photometrics_images/SG25/SphereGray5/'
% './photometrics_images/SG25/SphereGray6/'
% './photometrics_images/SG25/SphereGray9/'
% './photometrics_images/SG25/SphereGray12/'
% './photometrics_images/SG25/SphereGray15/'
% './photometrics_images/SG25/SphereGray18/'
% './photometrics_images/SG25/SphereGray21/'
% './photometrics_images/SG25/SphereGray24/'
% './photometrics_images/SG25/SphereGray25/'
% };
%%-------------------------------------------------------------
%%% Sphere Gray 25A
%%-------------------------------------------------------------
% base           = './R25A';
% image_dir_list = {
% './photometrics_images/SG25A/m16/'
% './photometrics_images/SG25A/m17/'
% './photometrics_images/SG25A/m24/'
% './photometrics_images/SG25A/m25/'
% };
%%-------------------------------------------------------------
%%% Sphere Gray 25B
%%-------------------------------------------------------------
% base           = './R25B';
% image_dir_list = {
% './photometrics_images/SG25B/m1/'
% './photometrics_images/SG25B/m4/'
% './photometrics_images/SG25B/m5/'
% './photometrics_images/SG25B/m8/'
'./photometrics_images/SG25B/m9/'
% './photometrics_images/SG25B/m12/'
% './photometrics_images/SG25B/m13/'
% './photometrics_images/SG25B/m16/'
% './photometrics_images/SG25B/m17/'
% './photometrics_images/SG25B/m24/'
% './photometrics_images/SG25B/m25/'
% };
%%-------------------------------------------------------------
%%% Sphere Gray 25 C
%%-------------------------------------------------------------
% base           = './R25C';
% image_dir_list = {
% './photometrics_images/SG25C/m3'
% './photometrics_images/SG25C/m5'
% './photometrics_images/SG25C/m6'
% './photometrics_images/SG25C/m8'
% };
% 
%%-------------------------------------------------------------
%%% Sphere Gray 25 D - Integaribilty obseva
%%-------------------------------------------------------------
base           = './R25D';
image_dir_list = {
'./photometrics_images/SG25D/m4'
'./photometrics_images/SG25D/m9'
};
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

% Z_heights_list = [0.25, 0.50, 0.75, 1.00];

% true_false_list = [false, true];
true_false_list = [true];
Z_heights_list = [0.50];
use_linsolve   = false;
display_plots  = 'off';
save_plots     = true;

for idx =1:length(image_dir_list)
    disp('  ')
    img_dir = image_dir_list{idx};
    dir_name = split(image_dir_list{idx}, '/');
    dir_name = dir_name{size(dir_name,1)-1};
    for Z_dist = Z_heights_list
        for shadow_trick = true_false_list
            disp(' ');
            disp('---------------------------------------------------------------------------------------------');
            fprintf('z height: %3.2f Folder: %s  shadow_trick: %s  linsolve: %s\n' ,Z_dist, dir_name,...
                        mat2str(shadow_trick), mat2str(use_linsolve));
            disp('---------------------------------------------------------------------------------------------');
            disp(' ');
            disp('Loading images...')
            [image_stack, scriptV, V, normV] = load_syn_images(img_dir, '*.png',1 ,Z_dist);
            [albedo, normals] = process_image_stack(image_stack, scriptV, use_linsolve, Z_dist, shadow_trick,  display_plots, save_plots, base);
               
            %%- PROCESS ALBEDO and NORMALS - BUILD SURFACE


            [hm_col, hm_row, hm_avg, SE] = process_normals(albedo, normals, size(image_stack,3), Z_dist, shadow_trick,  display_plots, save_plots, base);
            end
        end
    end
disp(' Processing finished');
