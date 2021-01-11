
%=====================================================================
%
%	GaussianKernel 
%  --------------
%
%	Parameters:   
%		x,y     - 2 data points. 
%		q		- The width of the gaussian kernel.
%                   
%	Return Value:
%		k	    - The inner product of the pair of data points images.
%
%		Computes the Gaussian Kernel:
%		The inner product of the images of a given data points' pair.
%   
%   	k = K(x,y) = exp( -q * ||x - y||^2 ) 
%
%=====================================================================

function k = GaussianKernel(x,y,q)

k = exp(-q * (x-y)' * (x-y));
