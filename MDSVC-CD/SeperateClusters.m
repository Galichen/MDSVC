
%=====================================================================
%
%   SeperateClusters
%   ----------------
%
%   Parameters:   
%		Samples         - The matrix holds the data points.
%		beta 	        - The vector of the Lagrangian multipliers.
%		quad	        - The quadratic part of the distace from the sphere's
%					      center.
%		R		        - The minimal sphere's radius.
%       q		        - The width of the gaussian kernel.
%       classification  - The apriori classifications for each Data point.
%
%	Return Value:
%		clusters_assignments -
%		        A vector of the clusters assignments assigned by the algorithm 
%		        to the data points.
%       maj_class - The classifications assigned by the algorithm to each point.
%       mis_class - The number of errors of the assigned classification against 
%                   the apriori classifications.
%       nof_samples_per_class_per_cluster
%
%	The sphere is mapped back to data space, where it forms a set 
%	of contours which enclose the data points.
%	These contours are interpeted as clusters boundaries. 
%
%=====================================================================

function [ClusterPerQ,clusters_assignments] =SeperateClusters(Samples,beta,quad,R,q,classification)

[attr,N] = size(Samples);
tp = 0;
tn = 0;
% calculates the adjacent matrix
adjacent_matrix = FindAdjMatrix(Samples,N,beta,quad,R,q);

% Finds the cluster assignment of each data point 
clusters_assignments = FindConnectedComponents(adjacent_matrix,N);
ClusterPerQ = max(clusters_assignments);
%
%for i=1:N
%    for j=1:N
%       if (classification(i) == classification(j) && clusters_assignments(i) ==clusters_assignments(j)) 
%           tp = tp + 1;
%      elseif (classification(i) ~= classification(j) && clusters_assignments(i) ~=clusters_assignments(j))
%         tn = tn + 1;
%     end
%  end
end
%a = N*(N-1);
%RI = (tp + tn)/a; 
