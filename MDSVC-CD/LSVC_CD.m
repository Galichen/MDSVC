function  [beta,alpha, time] = LSVC_CD(Samples, params)

%Samples:DATA
%params: vector: [lambda1, lambda2, C,q]
%kerType: rbf

%% params
lambda1 = params(1);
lambda2 = params(2);
C = params(3);
q = params(4);

%% data size
[dim, num] = size(Samples);
%% Q = Kernel Matrix  
%G = zeros(num);
Q = KernelMatrix(Samples,q); 
% processing
Q = (Q + Q')/2 ;%+ 0.001*eye(size(Q));
%% H =initialize alpha and D=QT
%T = sparse(zeros(num, num));
it = tic;
T=CalcG(lambda1,lambda2,Q,num);
H = lambda1/num*T*sparse(ones(num, 1));
D = 2*Q*T;% 2QG
time = toc(it);

%% prob
prob.H = H;
prob.Q = Q;
prob.D = D; 
prob.T = T; 

%% beta,alpha
tstart = tic;
alpha = trainLSVC_CD(sparse(Samples), prob, params);
beta = T\(alpha-H);
time = time + toc(tstart);

end