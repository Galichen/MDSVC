%=====================================================================
%   LSVC althgroim   Minum mean
%	Calculate   matrix G=inver((lamda1+1)K+H+P)K,K=kernelmatrix
%	------------
%
%	Parameters:   
%		lamda1 - Matrix, holds the data points.
%		lamda2		- The width of the Gaussian kernel.
%        K       - The inner product of all samples' images pairs.
%        N      - Number of Samples           
%	Return Value:
%		G      - The matrix.
%	
%		The inner products of the points images 
%	 	represented by an appropriate Mercer Kernel: 
%	 	we use the Gaussian Kernel.
%
%=====================================================================
function [G]=CalcG(lamda1,lamda2,K,N)

% initialization - N*N matrix
G = zeros(N);
S = zeros(N);
U = zeros(N);
for i=1:N
    G=G+K(:,i)*K(:,i)';
    for j=1:N
        S = S + K(:,i)*K(:,j)';
    end    
end
T=roundn(8*lamda2/N,-4)*G+roundn(8*lamda2/(N^2),-4)*S+(1+lamda1)*K;
for i=1:N
    for j=1:i
        U(i,j)=roundn(T(i,j),-4);
        U(j,i)=U(i,j);
    end
end
%T=(T'+T)/2;
T=U;
G = T\sparse(K);