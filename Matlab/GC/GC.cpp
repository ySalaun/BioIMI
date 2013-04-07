#include "mex.h"
#include "math.h"

#include "graph.h"
#include "graph.cpp"
#include "maxflow.cpp"


// Error message
void error_msg(char* msg)
{
	mexWarnMsgTxt("Error");
	mexWarnMsgTxt("Usage: [label_map] = GC(I, proba_map, ellipsoid_params, lambda)");
	mexErrMsgTxt(msg);
}

// Data term
double data(double r, double g, double b, int label)
{
	// TO FILL
	return 0.0;
}

// Smoothness term
double smoothness(int label1, int label2)
{
	// TO FILL
	return 0.0;
}

// binary graph_cut
void graph_cut(double* I, double* proba_map, double* label_map, int W, int H, int L, double lambda)
{
	// parameters
	int Npix = W*H*L;						// number of pixels in the picture
	int WH = W*H;							// offset for pixels
	
	// variables declaration
	int p, i, j, k;							// pixel variables
	double E0, E1, E00, E01, E10, E11;		// energy variables
	double capacity;							// min cut capacity
	bool non_submodular = false;			// boolean that inform us if the graph is submodular 
	Graph* g;								// graph
	Graph::node_id *nodes;					// nodes table

	// graph allocation   
	g = new Graph(Npix, 2*Npix, &error_msg);
	if(g == NULL){
		error_msg("Memory allocation for the graph failed!");
	}

	// Nodes allocation
	nodes = new Graph::node_id[Npix];
	if(nodes==NULL){
		error_msg("Memory allocation failed! (array of nodes could not be created)");
	}
	for(p = 0; p < Npix; ++p){
		nodes[p] = g->add_node();
	}
	
	// Graph construction
	
	// Edges
	p = -1;
	for(k = 0; k < L; ++k)
	{
		for(j = 0; j < H; ++j)
		{
			for(i = 0; i < W; ++i)
			{
				++p;									// current pixel coordinate
				
				// data terms
				E0 = 0;//data(/*TO FILL*/);				// data term for label 0
				E1 = 0;// data(/*TO FILL*/);				// data term for label 1
				
				if(E0<E1){							// edge source	->	pixel p
					g -> add_tweights(nodes[p], E1-E0, 0);
				}
				else{								// edge pixel p	->	sink
					g -> add_tweights(nodes[p], 0, E0-E1);
				}
				
				// smoothness terms
				// i-neighbor
				if(i > 1)
				{
					E00 = lambda*smoothness(0,0);
					E01 = lambda*smoothness(0,1);
					E10 = lambda*smoothness(1,0);
					E11 = lambda*smoothness(1,1);
					
					if(E10 > E00){					// edge source		->	pixel p
						g -> add_tweights(nodes[p], E10-E00, 0);
					}
					else{							// edge pixel p		->	sink
						g -> add_tweights(nodes[p], 0, E00-E10);
					}
					
					if(E11 > E10){					// edge source		->	pixel p - 1
						g -> add_tweights(nodes[p - 1], E11-E10, 0);
					}
					else{							// edge pixel p - 1	->	sink
						g -> add_tweights(nodes[p - 1], 0, E10-E11);
					}
					
					if(E01 + E10 - E00 - E11 >= 0){	// edge pixel p 	->	pixel p - 1
						g -> add_edge(nodes[p], nodes[p - 1], E01 + E10 - E00 - E11, 0);
					}
					else{
						non_submodular = true;
					}
				}
				// j-neighbor
				if(j > 1)
				{
					E00 = lambda*smoothness(0,0);
					E01 = lambda*smoothness(0,1);
					E10 = lambda*smoothness(1,0);
					E11 = lambda*smoothness(1,1);
					
					if(E10 > E00){					// edge source		->	pixel p
						g -> add_tweights(nodes[p], E10-E00, 0);
					}
					else{							// edge pixel p		->	sink
						g -> add_tweights(nodes[p], 0, E00-E10);
					}
					
					if(E11 > E10){					// edge source		->	pixel p - W
						g -> add_tweights(nodes[p - W], E11-E10, 0);
					}
					else{							// edge pixel p - W	->	sink
						g -> add_tweights(nodes[p - W], 0, E10-E11);
					}
					
					if(E01 + E10 - E00 - E11 >= 0){	// edge pixel p 	->	pixel p - W
						g -> add_edge(nodes[p], nodes[p - W], E01 + E10 - E00 - E11, 0);
					}
					else{
						non_submodular = true;
					}
				}
				// k-neighbor
				if(k > 1)
				{
					E00 = lambda*smoothness(0,0);
					E01 = lambda*smoothness(0,1);
					E10 = lambda*smoothness(1,0);
					E11 = lambda*smoothness(1,1);
					
					if(E10 > E00){					// edge source		->	pixel p
						g -> add_tweights(nodes[p], E10-E00, 0);
					}
					else{							// edge pixel p		->	sink
						g -> add_tweights(nodes[p], 0, E00-E10);
					}
					
					if(E11 > E10){					// edge source		->	pixel p - WH
						g -> add_tweights(nodes[p - WH], E11-E10, 0);
					}
					else{							// edge pixel p - WH->	sink
						g -> add_tweights(nodes[p - WH], 0, E10-E11);
					}
					
					if(E01 + E10 - E00 - E11 >= 0){	// edge pixel p 	->	pixel p - WH
						g -> add_edge(nodes[p], nodes[p - WH], E01 + E10 - E00 - E11, 0);
					}
					else{
						non_submodular = true;
					}
				}
			}
		}
	}

	if(non_submodular){
		mexWarnMsgTxt("Non submodular energy, troncature realized");
	}

	// min cut / max flow computation
	capacity = double(g -> maxflow());

	// segmentation
	for(p = 0; p < Npix; ++p)
	{
		// associate the pixel to the corresponding label
		if(g -> what_segment(nodes[p]) != (Graph::SOURCE)){
			label_map[p] = double(1);
		}
		else{
			label_map[p] = double(0);
		}
	}

	// free memory
	delete g;
	delete[] nodes;
}

// Matlab liaison
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	// check if argument number is correct
	if ( nrhs != 4 ) {
		error_msg("Wrong input number");
	} 
	else if ((nlhs != 1)) {
		error_msg("Wrong output number");
	}
	
	// INPUT PARAMETERS
	
	// picture
	// compute pictures dimensions
	const int* dim = mxGetDimensions(prhs[0]);
	int W = dim[0];
	int H = dim[1];
	int L = dim[2];
	double* I = (double*)(mxGetPr(prhs[0]));
	
	// probability map
	double* proba_map = (double*)(mxGetPr(prhs[1]));
	
	// ellipsoid parameters
	double* params = (double*)(mxGetPr(prhs[2]));
	
	// smoothness coefficient
	double lambda = double(*mxGetPr(prhs[3]));
	
	// OUTPUT PARAMETERS
	
	// segmentation map
	plhs[0] = mxCreateNumericArray(	mxGetNumberOfDimensions(prhs[0]),
									mxGetDimensions(prhs[0]), mxGetClassID(prhs[0]),
									mxREAL);
	double* label_map = (double*)(mxGetPr(plhs[0]));
	
	graph_cut(I, proba_map, label_map, W, H, L, lambda);
}

