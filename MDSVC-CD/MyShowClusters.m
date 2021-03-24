function  MyShowClusters(Samples,SV,BSV,clusters_assignments)
%,attr1,attr2)

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
    plot(Samples(1,cur_cluster)*10,Samples(2,cur_cluster)*10,'+','color',color_vector);

end
[attr,N] = size(Samples); 
for attr1 = 1:attr-1
    for attr2 = attr1+1:attr            
        % Plot the data points, highlights SVs and BSVs
        figure;
        plot(Samples(attr1,:),Samples(attr2,:),'bd',BSV(attr1,:),BSV(attr2,:),'r*',SV(attr1,:),SV(attr2,:),'g*');
        title(strcat('The Sample Points and the Support Vectors - Dimensions:',num2str(attr1),' and:',num2str(attr2))); 
        xlabel(strcat('Attribute: ',num2str(attr1))); 
        ylabel(strcat('Attribute: ',num2str(attr2))); 
        %legend ('Samples', 'Bounded Suuport Vectors' ,'Support Vectors',-1);
        hold on;
        % shows the different clusters 
        ShowClusters([Samples(attr1,:);Samples(attr2,:)],clusters_assignments,attr1,attr2);
    end

end
% title(strcat('The Clusters in 2D space - Dimension:',num2str(attr1),' and:',num2str(attr2))); 
% xlabel(strcat('Attribute: ',num2str(attr1))); 
% ylabel(strcat('Attribute: ',num2str(attr2))); 

hold off;