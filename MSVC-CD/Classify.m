%=====================================================================
%
%   Classify
%   ----------------
%
%   Parameters:   
%       classification  - The apriori classifications for each Data point.
%		clusters_assignments -
%		        A vector of the clusters assignments assigned by the algorithm 
%		        to the data points.
%
%	Return Value:
%       maj_class - The classifications assigned by the algorithm to each point.
%       mis_class - The number of errors of the assigned classification against 
%                   the apriori classifications.
%       nof_samples_per_class_per_cluster - as named...
%                   
%   Finds classification to each cluster, according to the majority
%   of apriori classifications of the cluster's data points.
%=====================================================================

function [maj_class, mis_class,nof_samples_per_class_per_cluster] = Classify(classifications, clusters_assignments)

nof_clusters = max(clusters_assignments);

% iterates through the clusters.
for clus_num = 1:nof_clusters
      
    % finds the majority of classifications in the current cluster.
    classification_per_cluster = classifications(find(clusters_assignments == clus_num));
    unique_classifications = unique(classifications);
    for i = 1:length(unique_classifications)
        nof_samples_per_class(i) = length(find(classification_per_cluster==unique_classifications(i))); 
    end
   
    nof_samples_per_class_per_cluster(clus_num,:) = nof_samples_per_class; 
     
    [max_rep,max_index] = max(nof_samples_per_class); 
    maj_class(clus_num) = unique_classifications(max_index);
    mis_class(clus_num) = sum(nof_samples_per_class) - max_rep;
    
    
end

