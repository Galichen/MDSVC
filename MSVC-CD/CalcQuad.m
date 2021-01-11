
%=====================================================================
%
%	CalcQuad:
%	---------
%
%	Parameters:   
%		N    - The number of Samples.
%		beta - Vector of the Lagrangian multipliers
%		K    - The Mercer Kernel (Gaussian)
%			   the inner product of the points' images.                
%
%	Return Value:
%		quad - sum over all pairs i,j : 
%			   beta(i) * beta(j) * image(i)image(j)
%       
%   Calculates the quadratic part of the Wolfe dual form,
%	and the distance from the sphere's center. (see docmentation)
%
%=====================================================================

function [quad] = CalcQuad(N,beta,K)

% initialization
quad = 0;

% sum over all data points' pairs
for i = 1:N
    for j = 1:N
        quad = quad + beta(i) * beta(j) * K(i,j);%�����N��beta�Ƿ�Ӧ�ÿ���beta(j)==0?����������ڴ�������ʱ,Ӧ�ÿ��Ƕ���С������.
    end
end

