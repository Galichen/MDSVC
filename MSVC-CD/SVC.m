
%=====================================================================
%
%	SVC - The main function in the project
%  ---
%
%	Parameters:   
%		Samples - Matrix, holds the data points.
%       C       - Parameter defines the fraction of points which 
%			      are allowed to become outliers.
%                 (p = 1/CN where N is the the total sampels number).
%       q		- The width of the gaussian kernel.
%
%   Return Values:
%		SV      - A matrix containing the Support vectors.
%		BSV     - a matrix containing the outliers.
%		beta    - Vector of the Lagrangian multipliers.
%		quad    - The quadratic part of the equation for
%                 the distance from the sphere's center.
%		R       - The minimal enclosing sphere radius.
%  
%	Algorithm:
%		Data points are mapped from data space to a high dimentional
%		feature space, using a Gaussian Kernel.
%		In feature space we search for the minimal sphere that encloses
%		the images of the the data.
%	
%=====================================================================

function [SV,BSV,beta,quad,R,RI,Accuracy,ClusterPerQ,clusters_assignments] = SVC(Samples,classification,C,q)

[attr,N] = size(Samples);

% Calculates the Kernel Matrix 
% Marcer kernel: here we use Gaussian kernel
K = KernelMatrix(Samples,q);

% Finds the Lagrangian multipliers, for the given constrains
beta = SolveLagrangian(N,K,C);

% Finds the support vectors and outliers
[SV,nof_SV,BSV,nof_BSV] = FindSVandBSV(Samples,beta,C);

% Calcultes the radius of the sphere, 
% and the quadratic part of the distance equation from the sphere's center.
[quad,R] = CalcSphereRadius(Samples,SV,nof_SV,beta,K,q);
[RI,ClusterPerQ,clusters_assignments,maj_class, mis_class,nof_samples_per_class_per_cluster] =...
                            SeperateClusters(Samples,beta,quad,R,q,classification);
