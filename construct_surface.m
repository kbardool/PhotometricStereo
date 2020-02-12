function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface

if nargin == 2
    path_type = 'column';
end

fprintf(' Computing using path_type %s \n', path_type)
[height, width, ~] = size(p);
height_map = zeros(height, width);

sum  = zeros(height, width);

% fprintf(' height %d %d  width %d %d \n ', height, width)

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        % =================================================================
        height_map(1,1) = 0;
        % integrate along leftmost column to obtain f(x,0) first
        for row = 2:height
            height_map(row,1) = height_map(row-1,1) + q(row,1);
        end
        % integrate along each row
        for col = 2:width
             height_map(:,col) = height_map(:,col-1) + p(:,col);
        end
       
    case 'row'
        % =================================================================
        % YOUR CODE GOES HERE
        % =================================================================
        height_map(1,1) = 0;
        % integrate along top row to obtain f(0,y) first
        for col = 2:width
            height_map(1,col) = height_map(1,col-1) + p(1,col);
        end
        % integrate along each column
        for row = 2:height
             height_map(row,:) = height_map(row-1,:) + q(row,:);
        end
          
    case 'average'
        % =================================================================
        % YOUR CODE GOES HERE      
        % =================================================================
        height_map(1,1) = 0;
        % integrate using 'column' method 
        for row = 2:height
            height_map(row,1) = height_map(row-1,1) + q(row,1);
        end
        
        for col = 2:width
             height_map(:,col) = height_map(:,col-1) + p(:,col);
        end
        sum = height_map;
        
        % integrate using 'row' method
        height_map = 0; 
        
        for col = 2:width
            height_map(1,col) = height_map(1,col-1) + p(1,col);
        end
        
        for row = 2:height
             height_map(row,:) = height_map(row-1,:) + q(row,:);
        end
        sum = sum + height_map;
        height_map = sum / 2;
end


end

