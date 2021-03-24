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
distance = zeros(nof_SV,1);  %  ֻ����֧�����������ĵľ���

% Calculates the quadratic part of the distance from the sphere's center
quad = CalcQuad(N,beta,K);   %  ����������ֵ %%%ʵ��������Ϊbeta����ֵ������Ҫȫ�����㡣

% Calculates distance from the sphere's center for all Support Vectors. 
for i = 1:nof_SV
   distance(i) = DistFromCenter(Samples,N,beta,q,SV(:,i)) + quad;  %�����k��x,x������ͨ����K�ĶԽ����ã�������Ҫ�ټ���
end

R = max(distance); % �����е�֧�������У�Ӧ���ǻ�ȡ���İ뾶����������˵���뾶�Ѿ��Ż�Ϊ��С��ͬʱ�����Բ�����ƽ��ֵ�ķ�����ð뾶ֵ
%                      ֧�����������������ϣ����ԣ�����õ����еľ���Ӧ������ȵ�
% safty check: all the SV distances should be equal 
if (distance/R ~= ones(nof_SV,1))
   printf('error calculating sphere radius,please enter a new set of parameters'); 
   R = -1;
   return;
end

