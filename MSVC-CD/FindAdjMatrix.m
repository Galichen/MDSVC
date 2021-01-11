
%=====================================================================
%
%   FindAdjMatrix
%   -------------
%
%   Parameters:   
%		Samples - This matrix holds the data points.
%       N       - The Number of samples.
%		beta 	- Vector of the Lagrangian multipliers.
%		quad    - The quadratic part of the distance from the sphere's
%				  center.
%	    R		- The minimal sphere's radius.
%       q		- The width of the gaussian kernel.
%
%	Return Value:
%		adjacent - The adjacent matrix.
%
%	The Adjacency matrix between pairs of points whose images lie in
%	or on the sphere in feature space. 
%	(i.e. points that belongs to one of the clusters in the data space)
%
%	given a pair of data points that belong to different clusters,
%	any path that connects them must exit from the sphere in feature
%	space. Such a path contains a line segment of points y, such that:
%	DistFromCenter(y)>R.
%	Checking the line segment is implemented by sampling a number of 
%   points (10 points).
%	
%	BSVs are unclussfied by this procedure, since their feature space 
%	images lie outside the enclosing sphere.
%
%=====================================================================

function [adjacent] = FindAdjMatrix(Samples,N,beta,quad,R,q)

adjacent = zeros(N);

for i = 1:N %rows
   for j = 1:N %columns
       
       % if the j is adjacent to i - then all j adjacent's are also adjacent to i.
       if j<i
       
          if (adjacent(i,j) == 1)
              adjacent(i,:) = (adjacent(i,:) | adjacent(j,:));    %%%   ？？？？？？？？？
              %  如果点i和点j相邻，也就是说，i，j属于同一类；
              %  那么，和点j相邻的点必定也和点i相邻（属于同一类）；
              %  反过来结论也成立！ （这是对上一个语句的解释）
          end
          
       else
           
            % if adajecancy already found - no point in checking again  ％％％这时候考察的（i,j）对的距离而判断该点的值
            if (adjacent(i,j) ~= 1)
                % goes over 10 points in the interval between these 2 Sample points
                adj_flag = 1; % unless a point on the path exits the shpere - the points are adjacnet
                for interval = 0:0.1:1
                    z = Samples(:,i) + interval * (Samples(:,j) - Samples(:,i));
                    % calculates the sub-point distance from the sphere's center 
                    d = DistFromCenter(Samples,N,beta,q,z) + quad;
                    if d > R
                       adj_flag = 0;
                       interval = 1;
                    end
                end
                if adj_flag == 1
                   adjacent(i,j) = 1;
                   adjacent(j,i) = 1;
                end
            end
        end 
    end
end
 

