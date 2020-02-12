function [ image_stack, scriptV ,V, normV] = load_syn_images( image_dir, fn_pattern, channel, Z )
%LOAD_SYN_IMAGES read from directory image_dir all files with extension png
%   image_dir: path to the image directory
%   nchannel: the image channel to be loaded, default = 1
%
%   image_stack: all images stacked along the 3rd channel
%   scriptV: light directions


if nargin < 4
    Z = 0.5;
end
if nargin < 3
    channel = 1;
end

if nargin < 2
    fn_pattern = '*.png';
end 

files = dir(fullfile(image_dir, fn_pattern));
nfiles = length(files);
fprintf('  Number of files %d ,  Z is : %f \n', nfiles, Z);

image_stack = 0;
V = 0;


for i = 1:nfiles
    % read input image
    im = imread(fullfile(image_dir, files(i).name));
    im = im(:, :, channel);
    
    % stack at third dimension
    if image_stack == 0
        [h, w] = size(im);
        fprintf('  Image size (HxW): %d x%d \n', h, w);
        image_stack = zeros(h, w, nfiles, 'uint8');
        V = zeros(nfiles, 3, 'double');
    end
    
    image_stack(:, :, i) = im;
    
    % read light direction from image name
    name = files(i).name(8:end);
    m = strfind(name,'_')-1;
    X = str2double(name(1:m));
    n = strfind(name,'.png')-1;
    Y = str2double(name(m+2:n));
%     fprintf('  Image File: %-30s  Light source (x,y,z) : %6.3f  %6.3f %6.3f \n',files(i).name,X,Y,Z)  
    V(i, :) = [-X, Y, Z];
end

% normalization
min_val = double(min(image_stack(:)));
max_val = double(max(image_stack(:)));
image_stack = (double(image_stack) - min_val) / (max_val - min_val);

normV = sqrt(sum(V.^2, 2));
scriptV = bsxfun(@rdivide, V, normV);
fprintf('  Finished loading %d images.\n\n', nfiles);

end

