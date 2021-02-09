# MDSVC
A Matlab code for the minimum  distribution  for support vector clustering.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %% 

clc
close all

addpath(genpath('MDSVC-CD'))
%% %%%------------------------kernel MSVC----------------------%%%

load('iris.mat');

%% set parameters
C = 0.01;q = 1;lambda1 = 0.5;lambda2 = 0.01;
[SV,BSV,beta,alpha,quad,R,ClusterPerQ,clusters_assignments]  = LSVC(Samples,classification,C,q,lambda1,lambda2);
labels_pre = clusters_assignments;

%% evaluation%%

RI = RandIndex(labels_pre,classification);

AC = cluster_acc(classification,labels_pre);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

