%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %% exam
clc
close all
addpath(genpath('MDSVC-CD'))
%% %%%------------------------kernel MDSVC----------------------%%%
load('iris.mat');
%% set parameters
C = 0.01;q = 1;lambda1 = 0.5;lambda2 = 0.01;
[SV,BSV,beta,alpha,quad,R,ClusterPerQ,clusters_assignments]  = LSVC(Samples,classification,C,q,lambda1,lambda2);
labels_pre = clusters_assignments;
%% evaluation
ARI = RandIndex(labels_pre,classification);
ACC = cluster_acc(classification,labels_pre);
