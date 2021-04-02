# MDSVC
A Matlab code for the minimum  distribution  for support vector clustering.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %% 

clc
close all

addpath(genpath('MDSVC-CD'))


%% %%%------------------------kernel MDSVC----------------------%%%

load('dbmoon.mat');

%% set parameters 


C = 0.1;q = 0.1;lambda1 = 1;lambda2 = 4;


%% Model and visualization %%


[SV,BSV,beta,alpha,quad,R]  = MDSVC(Samples,classification,C,q,lambda1,lambda2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

