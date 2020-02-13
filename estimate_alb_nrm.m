function [ albedo, normal , surface] = estimate_alb_nrm( image_stack, scriptV, shadow_trick, use_linsolve)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal

warnSave1 = warning('error','MATLAB:rankDeficientMatrix' );
warnSave2 = warning('error','MATLAB:singularMatrix');

[height, width, numimages] = size(image_stack);
if nargin < 4 
    use_linsolve = false;
end
if nargin < 3
    shadow_trick = true;
end


% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(height, width, 1);
normal = zeros(height, width, 3);
surface = zeros(height, width, 3);
eyeN   = eye(numimages);
singularMat = 0;
rankZeroMat = 0;
rankDeficientMat = 0;
AugRankLargerCnt = 0 ;
AugRankSmallerCnt = 0 ;
AugRankEqualCnt  = 0;
blackPixel = 0;
% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image arrayx
%   stack image values into a vector i
%   construct the diagonal matrix scriptI
%   solve scriptI * scriptV * g = scriptI * i to obtain g for this point
%   albedo at this point is |g|
%   normal at this point is g / |g|
% =========================================================================
tic
for r = 1:height
%     if (mod(r, 100) == 0)
%         fprintf(' row : %d \n', r)
%     end
    for c = 1:width
        i = squeeze(image_stack(r,c,:));
        if i == 0 
%             fprintf(' row: %4d col: %4d , pixels Zero: %.4f %.4f %.4f %.4f %.4f\n', r,c, i);
            blackPixel = blackPixel + 1;
        end
        if shadow_trick
           scriptI = diag(i);
            A = (scriptI * scriptV);
            b = (scriptI * i);
        else
            A = scriptV;
            b =  i;            
        end
        AugMat = [A, b];
        if rank(A) == 0
            rankZeroMat = rankZeroMat + 1;
        end        
        if rank(AugMat) > rank(A)
            AugRankLargerCnt = AugRankLargerCnt +1 ;
        elseif rank(AugMat) < rank(A)
            AugRankSmallerCnt = AugRankSmallerCnt + 1;
        else
            AugRankEqualCnt = AugRankEqualCnt + 1;
        end

        
        try
%             if use_linsolve
%                 g = linsolve(A, b); 
%                 surface(r,c,:) = g;        
%                 albedo(r,c,1)  = norm(g);
%                 normal(r,c,:)  = g/norm(g);                
%             else                
                g = A \ b;
                surface(r,c,:) = g;        
                albedo(r,c,1)  = norm(g);
                normal(r,c,:)  = g/norm(g);                    
%             end
        catch ME
            switch ME.identifier
                case 'MATLAB:singularMatrix'
                    singularMat = singularMat +1;
                case 'MATLAB:rankDeficientMatrix'                            
                    rankDeficientMat = rankDeficientMat + 1;
                otherwise  
                    fprintf(' identifier: %s , message: %s ',ME.identifier,ME.message);
            end                                 
        end

    end
end
t2 = toc;


fprintf('   Using Shadow Trick : %s    Using mldsolve: %s  linsolve: %s\n', ....
            mat2str(shadow_trick), mat2str(~use_linsolve), mat2str(use_linsolve) );
fprintf('   Number of Pixels= [0,0,0]: %d \n\n',blackPixel);
fprintf('   Rank(AugMat) > Rank(A)   : %d \n',AugRankLargerCnt);
fprintf('   Rank(AugMat) = Rank(A)   : %d \n',AugRankEqualCnt);
fprintf('   Rank(AugMat) < Rank(A)   : %d \n\n',AugRankSmallerCnt);
fprintf('   Number of Rank Zero      : %d \n',rankZeroMat);
fprintf('   Number of Singular Mats  : %d \n',singularMat);
fprintf('   Number of Rank Deficient : %d \n\n',rankDeficientMat);

fprintf('   Pixels with Albedo > 1.0 : %d \n',size(find(albedo > 1.0),1)); 
fprintf('   Pixels with Albedo > 1.5 : %d \n',size(find(albedo > 1.5),1));
fprintf('   Pixels with Albedo > 2.0 : %d \n\n',size(find(albedo > 2.0),1));

fprintf('   Albedo      min: %8.4f  max: %8.4f \n', min(albedo,[],'all'), max(albedo,[],'all'));
fprintf('   Normals X   min: %8.4f  max: %8.4f \n', min(normal(:,:,1),[],'all'), max(normal(:,:,1),[],'all'));    
fprintf('   Normals Y   min: %8.4f  max: %8.4f \n', min(normal(:,:,2),[],'all'), max(normal(:,:,2),[],'all'));    
fprintf('   Normals Z   min: %8.4f  max: %8.4f \n', min(normal(:,:,3),[],'all'), max(normal(:,:,3),[],'all'));   
fprintf('Completed in %.5f seconds \n',t2)
warning(warnSave1);
warning(warnSave2);
end

