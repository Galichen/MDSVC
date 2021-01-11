clear all;
clc;
mex CFLAGS="\$CFLAGS -std=c99" -largeArrayDims trainLSVC_CD.cpp ./blas/daxpy.c ./blas/ddot.c ./blas/dnrm2.c ./blas/dscal.c