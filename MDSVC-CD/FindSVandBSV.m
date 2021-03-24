
%=====================================================================
%
%	FindSVandBSV
%	------------
%
%	Parameters:   
%		Samples - The matrix hold the data points.
%		beta    - The vector of the Lagrangian multipliers. 
%       C       - Defines the fraction of points which are allowed
%                 to become outliers.
%                 (p = 1/CN where N is the the total sampels number).
%                   
%	Return Value:
%		SV      - This matrix holds the Support vectors.
%       nof_SV  - The number of Support vectors produced.
%		BSV     - This matrix holds the outliers.
%       nof_BSV - The number of outliers produced.
%       
%
%   Finds the support vectors and outliers (Bounded Support Vectors)
%	of a cluster.
%
%=====================================================================

function [SV,nof_SV,BSV,nof_BSV] = FindSVandBSV(Samples,beta,C)

[attr,N] = size(Samples);
% initialization
BSV = zeros(attr,N);
SV = zeros(attr,N);
nof_BSV = 0;
nof_SV = 0;

for i = 1:N   
    
    % BSV - outliers ( only when beta equlas C - the upper bound)
    if beta(i) == C;
       nof_BSV = nof_BSV + 1; 
       BSV(:, nof_BSV) = Samples(:,i);
   
    
    elseif beta(i)>1e-6 
           nof_SV = nof_SV + 1;
           SV(:,nof_SV) = Samples(:,i);
    end
    
end

% Corrects the matrics sizes
BSV = BSV(:, 1:nof_BSV);
SV = SV(:,1:nof_SV);
if nof_SV~=N
    [SV,nof_SV,BSV,nof_BSV] = FindSV_BSV(Samples,beta,C);
end

