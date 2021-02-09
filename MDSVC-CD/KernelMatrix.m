
%=====================================================================
%
%	KernelMatrix 
%	------------
%
%	Parameters:   
%		Samples - Matrix, holds the data points.
%		q		- The width of the Gaussian kernel.
%                   
%	Return Value:
%		K       - The inner product of all samples' images pairs.
%	
%		The inner products of the points images 
%	 	represented by an appropriate Mercer Kernel: 
%	 	we use the Gaussian Kernel.
%
%=====================================================================

function [K] = KernelMatrix(Samples,q)

[attr,N] = size(Samples);

% initialization - N*N matrix
K = zeros(N);

for i = 1:N
    for j = 1:N
        % Calculate the Gaussian Kernel for each data points' pair.
        K(i,j) = roundn(GaussianKernel(Samples(:,i),Samples(:,j),q),-4);
    end
end
K = (K + K')/2 + 0.001*eye(size(K));
save KerM K



