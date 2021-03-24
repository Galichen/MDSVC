
%=====================================================================
%
%   ShowClusters
%   ----------------
%
%   Parameters:   
%		Samples         - This matrix holds the data points.
%		clusters_assignments -
%		        A vector of the clusters assignments assigned by the algorithm 
%		        to the data points.
%       attr1, attr2    - The dimensions of the current 2D space.
%
%	Presents graph showing the different clusters.
%
%=====================================================================


function [] = ShowClusters(Samples,clusters_assignments,attr1,attr2)


nof_clusters = max(clusters_assignments);
color_vector = zeros(1,3);

figure;
% iterates over all the clusters.
for i = 1:nof_clusters
    cur_cluster = find(clusters_assignments == i);
    % assigns a color for the cluster (totally 7 colors)
    color = dec2bin(mod(i-1,7),3);
    color_vector(1)= str2num(color(1));
    color_vector(2)= str2num(color(2));
    color_vector(3)= str2num(color(3));
    
    hold on;
    % showing the current cluster
    plot(Samples(1,cur_cluster),Samples(2,cur_cluster),'+','color',color_vector);

end

title(strcat('The Clusters in 2D space - Dimension:',num2str(attr1),' and:',num2str(attr2))); 
xlabel(strcat('Attribute: ',num2str(attr1))); 
ylabel(strcat('Attribute: ',num2str(attr2))); 

hold off;