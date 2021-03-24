%=====================================================================
%
%	CalcSphereRadius:
%	-----------------
%
%	Parameters:   
%		Samples - This matrix holds the data points.       
%		SV		- This matrix holds the support vectors.
%		nof_SV  - The number of support vectors.
%		beta 	- Vector of the Lagrangian multipliers.
%		K       - The Mercer Kernel (Gaussian kernel)
%				  the inner product of the points images                
%		q		- The width of the gaussian kernel.
%
%	Return Values:
%		quad    - sum over all pairs i,j : 
%		          beta(i) * beta(j) * image(i)image(j)
%       R 		- The minimal sphere's radius. 
%
%	Finds the radius, R, of the minimal enclosing sphere.
%	R = { DistFromCenter(Samples(i)) | Samples(i) is a Support vector }
%	where, 
%	DistFromCenter(X) = K(X,X)-2*SumOverj(beta(j)*K(Samples(j),X)+quad.
%   
%	Calcultes the quadratic part of the distance from sphere's center,
%	returns its value in order not to calculate it twice.
%	 
%=====================================================================

function [quad,R] = CalcSphereRadius(Samples,SV,nof_SV,beta,K,q)

[attr,N] = size(Samples);


% initialization
distance = zeros(nof_SV,1);  %  只计算支持向量到球心的距离

% Calculates the quadratic part of the distance from the sphere's center
quad = CalcQuad(N,beta,K);   %  计算二次项的值 %%%实际上我认为beta有零值，不需要全部计算。

% Calculates distance from the sphere's center for all Support Vectors. 
for i = 1:nof_SV
   distance(i) = DistFromCenter(Samples,N,beta,q,SV(:,i)) + quad;  %这里的k（x,x）可以通过对K的对角阵获得，而不需要再计算
end

R = max(distance); % 在所有的支持向量中，应该是获取最大的半径。从整体上说，半径已经优化为最小；同时，可以采用求平均值的方法获得半径值
%                      支持向量都处于球面上，所以，所获得的所有的距离应该是相等的
% safty check: all the SV distances should be equal 
if (distance/R ~= ones(nof_SV,1))
   printf('error calculating sphere radius,please enter a new set of parameters'); 
   R = -1;
   return;
end

