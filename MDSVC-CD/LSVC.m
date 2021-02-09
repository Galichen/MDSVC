%=====================================================================
%
%	LSVC - The main function in the project
%  ---
%
%	Parameters:   
%		Samples - Matrix, holds the data points.
%       C       - Parameter defines the fraction of points which 
%			      are allowed to become outliers.
%                 (p = 1/CN where N is the the total sampels number).
%       q		- The width of the gaussian kernel.
%       lamda1,lamda2 -parameter
%   Return Values:
%		SV      - A matrix containing the Support vectors.
%		BSV     - a matrix containing the outliers.
%		beta    - Vector of the Lagrangian multipliers.
%		quad    - The quadratic part of the equation for
%                 the distance from the sphere's center.
%		R       - The minimal enclosing sphere radius.
%       alpha   - the sphere center coefficient
%  
%	Algorithm:
%		Data points are mapped from data space to a high dimentional
%		feature space, using a Gaussian Kernel.
%		In feature space we search for the minimal sphere that encloses
%		the images of the the data.
%	
%=====================================================================

function [SV,BSV,beta,alpha,quad,R,ClusterPerQ,clusters_assignments] = LSVC(Samples,classification,C,q,lambda1,lambda2)

[attr,N] = size(Samples);

% Calculates the Kernel Matrix 
% Marcer kernel: here we use Gaussian kernel
K = KernelMatrix(Samples,q);
%G = CalcG(lamda1,lamda2,K,N);
% Finds the Lagrangian multipliers, for the given constrains
%beta = LSVCSolveLagrangian(N,K,C,G,lamda1);
%alpha = CalcCenterCoef(beta,G,N,lamda1);
[beta,alpha, time] = LSVC_CD(Samples, [lambda1,lambda2,C,q]);
% Finds the support vectors and outliers
[SV,nof_SV,BSV,nof_BSV] = FindSVandBSV(Samples,beta,C);

% Calcultes the radius of the sphere, 
% and the quadratic part of the distance equation from the sphere's center.
[quad,R] = CalcSphereRadius(Samples,SV,nof_SV,alpha,K,q);
[ClusterPerQ,clusters_assignments] =SeperateClusters(Samples,beta,quad,R,q,classification) ;