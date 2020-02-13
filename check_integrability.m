function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

[height, width, ~] =  size(normals);

% initalization
p = zeros(height, width);
q = zeros(height, width);
SE = zeros(height, width);
% p = zeros(size(normals));
% q = zeros(size(normals));
% SE = zeros(size(normals));

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy
% ========================================================================
p(:,:) = normals(:,:,1) ./ normals(:,:,3);
q(:,:) = normals(:,:,2) ./ normals(:,:,3);
    
% % % for row = 1:height-1
% % %     p(row,:) = normals(row+1,:,3) - normals(row,:,3);
% % % end
% % % for col = 1:width-1
% % %     q(:, col) = normals(:,col+1,3) - normals(:, col,3);
% % % end

% ========================================================================
fprintf('   Before - Number of Norm_z = 0: %d    \n', size(find(normals(:,:,3) == 0),1 ));
fprintf('   Before - Number of NaNs  in p: %d   q: %d \n', size(find(isnan(p)),1), size(find(isnan(q)),1) );
fprintf('   Before - Number of Zeros in p: %d   q: %d \n', size(find(p == 0),1)  , size(find(q == 0),1) );
 

p(isnan(p)) = 0;
q(isnan(q)) = 0;

 
fprintf('   After  - Number of Zeros in p: %d   q: %d \n',size(find(p == 0 ),1),size(find(q ==0),1));
fprintf('   After  - Number of <> 0 in p : %d   q: %d \n',size(find(p ~= 0 ),1),size(find(q ~=0),1));
% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE
% ========================================================================
for row= 1:height-1
    for col = 1:width-1
            SE(row,col) = ( (p(row,col+1) - p(row,col)) - (q(row+1,col) - q(row,col)))^2;
%             fprintf(' row: %4d col: %4d , Normal is not Zero: %f %f %f \n', r,c, normals(r,c,:));            
    end
end

% ========================================================================




end

