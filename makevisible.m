close all
clc
clear all
true_false_list = [false, true];
image_dir_list = {
'_Albedo2D/'
'_AlbedoHistograms/'
'_Albedo/'
'_Normals/'
'_NormalsSurface/'
'_ShowHeightMaps/'
'_ShowHeightNormals/'
'_ShowModel/'
'_ShowResults/'
} ;
 
visible        = 'off';
visualize      = true;
base           = './R25';
fn_pattern     = '*.fig';


for idx =1:length(image_dir_list)
    disp('  ')
    img_dir = image_dir_list{idx};
%     dir_name = split(image_dir_list{idx}, '/');
%     dir_name = dir_name{size(dir_name,1)-1};
    fullPath   = fullfile(base, img_dir)
    searchPath = fullfile(fullPath, fn_pattern);
    files = dir(searchPath);
    nfiles = length(files);
    fprintf('  Dir %s   Number of files %d  \n', fullPath, nfiles);

    for f=1:nfiles
%         disp(strcat([fullPath,  files(f).name]))
        makevisible(fullPath, files(f).name)
    end
%     disp(files(f))
end 


function makevisible(folder, filename)
    file = fullfile(folder, filename);
    hFig = openfig(file);
    % Set CreateFcn callback
    set(hFig, 'CreateFcn', 'set(gcbo,''Visible'',''on'')'); 
    % Save Fig file
    savefig(hFig, file);
    close(hFig);
%      f=load(file,'-mat');
%      n=fieldnames(f);
%      f.(n{1}).properties.Visible='on';   % this line does not have much effect in 16b, used to be the key line in earlier versions.
%      f.(n{2}).GraphicsObjects.Format3Data.Visible='on';
%      save(file,'-struct','f')
     disp(file)
end