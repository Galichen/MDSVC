#include <float.h>
#include <stdarg.h>
#include <limits.h>
#include <locale.h>
#include <iostream> 
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
//#include "../linear.h"
#include <algorithm>
using std::random_shuffle;
#include "mex.h"
//#include "linear_model_matlab.h"

typedef signed char schar;
template <class T> static inline void swap(T& x, T& y) { T t=x; x=y; y=t; }
#ifndef min
template <class T> static inline T min(T x,T y) { return (x<y)?x:y; }
#endif
#ifndef max
template <class T> static inline T max(T x,T y) { return (x>y)?x:y; }
#endif

#ifdef MX_API_VER
#if MX_API_VER < 0x07030000
typedef int mwIndex;
#endif
#endif

#define CMD_LEN 2048
#define Malloc(type,n) (type *)malloc((n)*sizeof(type))
#define INF HUGE_VAL

#ifdef __cplusplus
extern "C" {
#endif
    
    extern double dnrm2_(int *, double *, int *);
    extern double ddot_(int *, double *, int *, double *, int *);
    extern int daxpy_(int *, double *, double *, int *, double *, int *);
    extern int dscal_(int *, double *, double *, int *);
    
struct feature_node
{
    int index;
    double value;
};
    
struct problem
{
    int  num, dim;
    double lambda1, lambda2, C, q;                                         //update
    struct feature_node **x; // instance
    double *Q;
    double *H;
    double *D;
	double *T; 
};

#ifdef __cplusplus
}
#endif



void print_null(const char *s) {}
void print_string_matlab(const char *s) {mexPrintf(s);}


void exit_with_help()
{
    mexPrintf(
            "Usage: [beta,alpha] = trainLSVC_CD(instance_matrix, prob, lsvc_parametes);\n"
            "prob: {H, Q,D,T}\n"
            "LSVC_parameters: [lambda1,lambda2, C, q] \n"
            "made by CJL"
            );
}

// struct parameter param;		// set by parse_command_line
 struct problem prob;		// set by read_problem
// struct model *model_;
 struct feature_node *x_space, *xi;

static void fake_answer(mxArray *plhs[])
{
    plhs[0] = mxCreateDoubleMatrix(0, 0, mxREAL);
}

double dot(struct feature_node *px, struct feature_node *py)
{
    double sum = 0;
    while(px->index != -1 && py->index != -1)
    {
        if(px->index == py->index)
        {
            sum += px->value * py->value;
            ++px;
            ++py;
        }
        else
        {
            if(px->index > py->index)
                ++py;
            else
                ++px;
        }
    }
    return sum;
}

double powi(double base, int times)
{
    int t;
    double tmp = base, ret = 1.0;
    
    for(t=times; t>0; t/=2)
    {
        if(t%2==1) ret*=tmp;
        tmp = tmp * tmp;
    }
    return ret;
}

int read_problem_sparse(const mxArray *prhs[])
{
    int i, j, k, low, high;
    mwIndex *ir, *jc;
    int  num_samples,elements;
    //double *condNumber;
    double *samples;
    double *para;
    //mxArray *instance_mat_col;
    //mxArray *prhs[1], *plhs[1];
    
        
    
    // process X , Y  and params
    //prhs[0] = mxDuplicateArray(instance_mat);
    //mexCallMATLAB(1, plhs, 1, prhs, "transpose");
    //instance_mat_col = plhs[0];                      //output of function
    //mexCallMATLAB(1, plhs, 1, prhs, "full");
         
    prob.num = (int) mxGetN(prhs[0]);          //get  col of matrix
     
     // each column is one instance
    //labels = mxGetPr(label_vec);
    samples = mxGetPr(prhs[0]);
	ir = mxGetIr(prhs[0]);
	jc = mxGetJc(prhs[0]);
    
    num_samples = (int) mxGetNzmax(prhs[0]);
    elements = num_samples + prob.num;
    prob.dim = (int) mxGetM(prhs[0]);                             //update
    //prob.y = Malloc(double, prob.num);
    prob.x = Malloc(struct feature_node*, prob.num);
    x_space = Malloc(struct feature_node, elements);                //update
    
    j = 0;
    for(i=0;i<prob.num;i++)
    {
        prob.x[i] = &x_space[j];
        //prob.y[i] = labels[i];
        low = (int) jc[i], high = (int) jc[i+1]; 
        for(k=low;k<high;k++)
        {
            x_space[j].index = (int) ir[k]+1;
            x_space[j].value = samples[k];
            j++;
        }
        x_space[j++].index = -1;
    }
   
    
    para = mxGetPr(prhs[2]);
    prob.lambda1 = para[0];
    prob.lambda2 = para[1];
    prob.C = para[2];
    prob.q = para[3];                                                      //update

    // read problem struct
    prob.H = mxGetPr(mxGetCell(prhs[1], 0));
    prob.Q = mxGetPr(mxGetCell(prhs[1], 1));
    prob.D = mxGetPr(mxGetCell(prhs[1], 2));                    //update
    prob.T = mxGetPr(mxGetCell(prhs[1], 3));
    
    return 0;
}

// A coordinate descent algorithm for
// L1-loss and L2-loss SVM dual problems
//
//  min_\alpha  0.5(\alpha^T (Q + D)\alpha) - e^T \alpha,
//    s.t.      0 <= \alpha_i <= upper_bound_i,
//
//  where Qij = yi yj xi^T xj and
//  D is a diagonal matrix
//
// In L1-SVM case:
// 		upper_bound_i = Cp if y_i = 1
// 		upper_bound_i = Cn if y_i = -1
// 		D_ii = 0
// In L2-SVM case:
// 		upper_bound_i = INF
// 		D_ii = 1/(2*Cp)	if y_i = 1
// 		D_ii = 1/(2*Cn)	if y_i = -1
//
// Given:
// x, y, Cp, Cn
// eps is the stopping tolerance
//
// solution will be put in w
//
// See Algorithm 3 of Hsieh et al., ICML 2008

//undef GETI
//define GETI(i) (y[i]+1)
// To support weights for instances, use GETI(i) (i)

static void solve_cd(
        const problem *prob, double *alpha, double eps)
{
    int num = prob->num;
    int dim = prob->dim;
    double lambda1 = prob->lambda1;                                //update
    double lambda2 = prob->lambda2;
    double C = prob->C;
    double q = prob->q;                                                    //update
    int i, s, iter = 0, inc = 1;
    double d, G;
    int max_iter = 1000;
    int *index = new int[num];
    double *beta = new double[num];
    //double* y = new double[num];
    int active_size = num;
    
    // PG: projected gradient, for shrinking and stopping
    double PG;
    double PGmax_old = INF;
    double PGmin_old = -INF;
    double PGmax_new, PGmin_new;
    
    for(i=0; i<num; i++)
    {
        //y[i] = prob->y[i];
        index[i] = i;
        
         //initialize \beta = 0
        beta[i] =  lambda1/num;                                                   //update
    }
    
   
  
    // kernel
    //initialize \w = (lamba1)/(m) Ge
    for(i=0; i<num; i++)
        {
            alpha[i] = 2*prob->H[i];
        }        
     
    while(iter < max_iter)                                                 //update
    {
        PGmax_new =-INF;
        PGmin_new =INF; // by lmz
        
        for(i=0; i<active_size; i++)
        {
            int j = i+rand()%(active_size-i);
            swap(index[i], index[j]);
        }
        
        for(s=0; s<active_size; s++)
        {
            i = index[s];
            G = 0;
            //double yi = y[i];
            
            // calculate gradient g[i]:
            // kernel: g[i] = (G; -G) \w^top + (\epsilon - y; \epsilon + y);
           for (int j = 0; j < num; j++)
				G += prob->Q[i * num + j] * alpha[j];                                         //update
            G = 2*G;  
            //mexPrintf("%d\n",G);
            PG = 0;
            if (beta[i] == 0)
            {
                if (G > PGmax_old)
                {
                    active_size--;
                    swap(index[s], index[active_size]);
                    s--;
                    continue;
                }
                else if (G < 0)
                {  
                    PG = G;
                    //mexPrintf("1");
                }
            }
            else if (beta[i] == C)                                     //update
            {
                if (G < PGmin_old)
                {
                    active_size--;
                    swap(index[s], index[active_size]);
                    s--;
                    continue;
                }
                else if (G > 0)
                {
                    PG = G;
                }
            }
            else
            {
                PG = G;
                PGmax_new = max(PGmax_new, PG);
                PGmin_new = min(PGmin_new, PG);
            }
            //mexPrintf("%d\n",PG);
            
            if(fabs(PG) > 1.0e-12)
            {
                double beta_old = beta[i];
                beta[i] = min(max(beta[i] - G/(prob->D[i*num + i]), 0.0), C);//update

                d = beta[i] - beta_old;
                for(int j=0; j<num; j++)
                    alpha[j] += prob->T[j*num + i] * d ;
                //mexPrintf("3");
            }
        }
               
        iter++;
        
        if(PGmax_new - PGmin_new <= eps)
        {
            
            if(active_size == num)
            {mexPrintf("Reach covergence \n");
                break;}
            else
            {
                active_size = num;
                PGmax_old = INF;
                PGmin_old = -INF;
                continue;
            }
        }
        PGmax_old = PGmax_new;
        PGmin_old = PGmin_new;

        if (PGmax_old == 0)
            PGmax_old = INF;
        if (PGmin_old == 0)
            PGmin_old = -INF;
     }
    

    mexPrintf("number of iterations is %d\n",iter);
    delete [] beta;
    //delete [] y;
    delete [] index;
}


// Interface function of matlab
// now assume prhs[0]: Samples
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[] )
{
    // Transform the input Matrix to libsvm format
    if(nrhs == 3)
    {
        int i, j;
        double* alpha = NULL;
        int err=0;
        
        if(!mxIsDouble(prhs[0])) {
            mexPrintf("Error:  instance matrix must be double\n");
            fake_answer(plhs);
            return;
        }
        
       if(mxIsSparse(prhs[0]))
            err = read_problem_sparse( prhs);
        else
        {
            mexPrintf("Training_instance_matrix must be sparse; "
                    "use sparse(Training_instance_matrix) first\n");
            fake_answer(plhs);
            return;
        }
               
        if(err)
        {
            fake_answer(plhs);
            return;
        }
        
        plhs[0] = mxCreateDoubleMatrix(prob.num, 1, mxREAL);
        alpha = mxGetPr(plhs[0]);
        
        solve_cd(&prob,alpha, 0.0001);       
    }
    else
    {
        exit_with_help();
        fake_answer(plhs);
        return;
    }
}
