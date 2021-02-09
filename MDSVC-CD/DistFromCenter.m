%===============================================================================
%
%   DistFromCenter: 
%   ---------------
%
%   Parameters:   
%       Samples  - This matrix holds the data points.
%       N        - The number of samples.
%       beta     - The Lagrangian multipliers
%		q		- The width of the gaussian kernel.
%       x        - The point to calculate its distance from the sphere's center. 
%                   
%   Return Value:
%       distance - The distance of point x's image from the sphere's center   
%
%   Computes the distance of point x's image from the sphere center
% 
%================================================================================

function [distance] = DistFromCenter(Samples,N,beta,q,x)

% initialization
k = zeros(N,1);

% Calculate the dot product of x's image, with each data point's image
for j = 1:N
    k(j) = GaussianKernel(Samples(:,j),x,q);    %   SumOverj(beta(j)*K(Samples(j),X)的值
end

% K(x,x)
kdiag = GaussianKernel(x,x,q); % =1   K(X,X)的值

distance = kdiag - 2*beta'*k;

