
%=====================================================================
%
%	SolveLagrangian:
%	----------------
%
%	Parameters:   
%		Samples - Matrix hold the data points.
%		N       - The number of Samples.
%		K       - The Kernel matrix (dot product of all images' pairs).
%       C       - Defines the fraction of points which are allowed
%                 to become outliers.
%                 (p = 1/CN where N is the the total sampels number).
%                   
%	Return Value:
%		beta    - The lagrangian multipliers.
%
%   	Finds the lagrangian multipliers using quadratic programming.
%
%=====================================================================

function [beta] = SolveLagrangian(N,K,C)


A = ones(1,N);
b = 1;
low_bound = zeros(N,1);
up_bound = ones(N,1) * C;

% Solves the quadratic programming problem:
% 
% 	Max over beta { diag(K)*beta - 0.5*beta'*2K*beta }
%
%   subject to: SumOveri(beta(i)) <= 1  (defined  by A and b)
%
%   The results are bounded to be   0 <= beta <= C (low_bound and hp_bound)

beta = quadprog(2*K, -diag(K),[],[], A, b, low_bound, up_bound);
         
