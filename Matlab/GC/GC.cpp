#include "mex.h"
#include "math.h"

#include "graph.h"
#include "graph.cpp"
#include "maxflow.cpp"

// Error message
void error_msg(char* msg)
{
	mexWarnMsgTxt("Error");
	mexWarnMsgTxt("Usage: [label_map] = GC(I, proba_map, ellipsoid_parameters [center direction_matrix rays], lambda)");
	mexErrMsgTxt(msg);
};


// class for 3 dimensions vectors
class Vector3D{
	public:
	double x, y, z;
    
    // constructors
    Vector3D(){}
	Vector3D(const double a, const double b, const double c){
		x = a;
		y = b;
		z = c;
	}
};

// computes the middle of two vectors
Vector3D middle(const Vector3D &u, const Vector3D &v){
    double a = (u.x + v.x) / 2.0;
    double b = (u.y + v.y) / 2.0;
    double c = (u.z + v.z) / 2.0;
    return Vector3D(a, b, c);
}

// computes the difference of two vectors
Vector3D diff(const Vector3D &u, const Vector3D &v){
    double a = u.x - v.x;
    double b = u.y - v.y;
    double c = u.z - v.z;
    return Vector3D(a, b, c);
}

// computes the scalar product of two vectors
double dotProduct(const Vector3D &u, const Vector3D &v){
    return u.x * v.x + u.y * v.y + u.z * v.z;
}

// computes the L2-norm of the difference of two vectors
double normDiff(const Vector3D &u, const Vector3D &v){
    double a = u.x - v.x;
    double b = u.y - v.y;
    double c = u.z - v.z;
    return a*a + b*b + c*c;
}

// class for ellipsoid
// contains:
//  - its center
//  - its 3 rays directions(X) and lengths (ray)
class Ellipsoid{
	public:
	Vector3D center;
    double *X, *ray;
	
	Ellipsoid(const double *p){
        center = Vector3D(p[0], p[1], p[2]);
        
        X = new double[9];
        for(int i = 0; i < 9; ++i){
            X[i] = p[3 + i];
        }
        
        ray = new double[3];
        for(int i = 0; i < 3; ++i){
            ray[i] = p[12 + i];
        }
	}
	
    // return true iif the vector X is inside the ellipsoid
    bool contains(const Vector3D &x){
        double sum = 0.0;
        Vector3D u = diff(x, center);
        for(int i=0; i<3; ++i){ 
            double scal = dotProduct(u,Vector3D(X[3 * i], X[3 * i + 1], X[3 * i + 2]))/ray[i];
            sum += scal*scal;
        }
        return sum <= 1;
    }
};

// return the minimum distance of the vector to the border along the 3 ellipsoid directions
// note that it is always positive and null iif the vector is along the border NOT inside the ellipsoid
double dis2border(const Ellipsoid &e, const Vector3D &x){
    double sum = 0.0;
    Vector3D u = diff(x, e.center);
    for(int i = 0; i < 3; ++i){ 
        double scal = dotProduct(u,Vector3D(e.X[3 * i], e.X[3 * i + 1], e.X[3 * i + 2]))/e.ray[i];
        sum += scal*scal;
    }
    if(sum < 0.001){
        double m = e.ray[0];
        for(int i = 1; i < 3; ++i){ 
            m = (m > e.ray[i])? e.ray[i] : m ;
        }
        return m;
    }
    sum = 1 / sqrt(sum);
    Vector3D y(e.center.x + sum * (x.x - e.center.x), e.center.y + sum * (x.y - e.center.y), e.center.z + sum * (x.z - e.center.z));
    return sqrt(normDiff(x,y));
}

// Data term
// depending on the probability p of belonging to label 0
double data(const double p, const double lambda, const int label)
{
	if(label == 0){
		return (1-lambda)*(1.0-p)*(1.0-p);
	}
	return (1-lambda)*p*p;
}

// Smoothness term
// positive only when the 2 neighbours belong to different labels
// depends on:
// - the location of their barycenter (that should be on the border)
// - their difference of intensity (that should be large)
// it is a linear combination of these two costs with lambda as parameter
double smoothness(	const int label1, const int label2,
					const double color1, const double color2,
					const Vector3D &pos1, const Vector3D &pos2,
                    const Ellipsoid &e, const double lambda)
{
    if(label1 == label2){
		return 0.0;
	}
	else{
		Vector3D bar 	= middle(pos1, pos2);
		double diff  	= (color1-color2);
		double sigma1	= 5;
		double sigma2	= 3;
        // penalization on the location of the barycenter
        double smooth1	= dis2border(e, bar);
        smooth1			= smooth1*smooth1/(sigma1*sigma1);
		smooth1			= (smooth1 > 1)? 1:smooth1;
        // penalization on the difference of their color intensity
        double smooth2	= exp(-diff*diff/(2*sigma2*sigma2));
        return smooth1 * lambda + smooth2 * (1 - lambda);
	}
    error_msg("error during smoothness term computation");
	return 0.0;
}

// binary graph_cut
void graph_cut(double* I, double* proba_map, double* label_map, Ellipsoid e, int W, int H, int L, double lambda)
{
	// parameters
	int Npix    = W*H*L;						// number of pixels in the picture
	int WH      = W*H;							// offset for pixels
	
	// variables declaration
	int p, i, j, k;                             // pixel variables
	double E0, E1, E00, E01, E10, E11;          // energy variables
	double capacity;							// min cut capacity
	bool non_submodular = false;                // boolean that inform us if the graph is submodular 
	Graph* g;                                   // graph
	Graph::node_id *nodes;                      // nodes table

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
				E0 = data(proba_map[p], lambda, 0);     // data term for label 0
				E1 = data(proba_map[p], lambda, 1);     // data term for label 1
				
				if(E0<E1){                              // edge source	->	pixel p
					g -> add_tweights(nodes[p], E1-E0, 0);
				}
				else{                                   // edge pixel p	->	sink
					g -> add_tweights(nodes[p], 0, E0-E1);
				}
				// smoothness terms
				// i-neighbor
				if(i > 1)
				{
					E00 = smoothness(0, 0, I[p], I[p-1], Vector3D(i, j, k), Vector3D(i-1, j, k), e, lambda);
					E01 = smoothness(0, 1, I[p], I[p-1], Vector3D(i, j, k), Vector3D(i-1, j, k), e, lambda);
					E10 = smoothness(1, 0, I[p], I[p-1], Vector3D(i, j, k), Vector3D(i-1, j, k), e, lambda);
					E11 = smoothness(1, 1, I[p], I[p-1], Vector3D(i, j, k), Vector3D(i-1, j, k), e, lambda);
					if(E10 > E00){                      // edge source		->	pixel p
						g -> add_tweights(nodes[p], E10-E00, 0);
					}
					else{                               // edge pixel p		->	sink
						g -> add_tweights(nodes[p], 0, E00-E10);
					}

					if(E11 > E10){                      // edge source		->	pixel p - 1
						g -> add_tweights(nodes[p - 1], E11-E10, 0);
					}
					else{                               // edge pixel p - 1	->	sink
						g -> add_tweights(nodes[p - 1], 0, E10-E11);
					}

					if(E01 + E10 - E00 - E11 >= 0){     // edge pixel p 	->	pixel p - 1
						g -> add_edge(nodes[p], nodes[p - 1], E01 + E10 - E00 - E11, 0);
					}
					else{
						non_submodular = true;
					}
				}
				// j-neighbor
				if(j > 1)
				{
					E00 = smoothness(0, 0, I[p], I[p-W], Vector3D(i, j, k), Vector3D(i, j-1, k), e, lambda);
					E01 = smoothness(0, 1, I[p], I[p-W], Vector3D(i, j, k), Vector3D(i, j-1, k), e, lambda);
					E10 = smoothness(1, 0, I[p], I[p-W], Vector3D(i, j, k), Vector3D(i, j-1, k), e, lambda);
					E11 = smoothness(1, 1, I[p], I[p-W], Vector3D(i, j, k), Vector3D(i, j-1, k), e, lambda);
					
					if(E10 > E00){                      // edge source		->	pixel p
						g -> add_tweights(nodes[p], E10-E00, 0);
					}
					else{                               // edge pixel p		->	sink
						g -> add_tweights(nodes[p], 0, E00-E10);
					}
					
					if(E11 > E10){                      // edge source		->	pixel p - W
						g -> add_tweights(nodes[p - W], E11-E10, 0);
					}
					else{                               // edge pixel p - W	->	sink
						g -> add_tweights(nodes[p - W], 0, E10-E11);
					}
					
					if(E01 + E10 - E00 - E11 >= 0){     // edge pixel p 	->	pixel p - W
						g -> add_edge(nodes[p], nodes[p - W], E01 + E10 - E00 - E11, 0);
					}
					else{
						non_submodular = true;
					}
				}
				// k-neighbor
				if(k > 1)
				{
					E00 = smoothness(0, 0, I[p], I[p-WH], Vector3D(i, j, k), Vector3D(i, j, k-1), e, lambda);
					E01 = smoothness(0, 1, I[p], I[p-WH], Vector3D(i, j, k), Vector3D(i, j, k-1), e, lambda);
					E10 = smoothness(1, 0, I[p], I[p-WH], Vector3D(i, j, k), Vector3D(i, j, k-1), e, lambda);
					E11 = smoothness(1, 1, I[p], I[p-WH], Vector3D(i, j, k), Vector3D(i, j, k-1), e, lambda);
					
					if(E10 > E00){                      // edge source		->	pixel p
						g -> add_tweights(nodes[p], E10-E00, 0);
					}
					else{                               // edge pixel p		->	sink
						g -> add_tweights(nodes[p], 0, E00-E10);
					}
					
					if(E11 > E10){                      // edge source		->	pixel p - WH
						g -> add_tweights(nodes[p - WH], E11-E10, 0);
					}
					else{                               // edge pixel p - WH->	sink
						g -> add_tweights(nodes[p - WH], 0, E10-E11);
					}
					
					if(E01 + E10 - E00 - E11 >= 0){     // edge pixel p 	->	pixel p - WH
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
    const int* param_nb = mxGetDimensions(prhs[2]);
    if(param_nb[0]*param_nb[1] != 15){
        error_msg("Wrong number of parameters for ellipsoid");
    }
    Ellipsoid e = Ellipsoid((double*)(mxGetPr(prhs[2])));
	
	// smoothness coefficient
	double lambda = double(*mxGetPr(prhs[3]));
	
	// OUTPUT PARAMETERS
	
	// segmentation map
	plhs[0] = mxCreateNumericArray(	mxGetNumberOfDimensions(prhs[0]),
									mxGetDimensions(prhs[0]), mxGetClassID(prhs[0]),
									mxREAL);
	double* label_map = (double*)(mxGetPr(plhs[0]));
	
	graph_cut(I, proba_map, label_map, e, W, H, L, lambda);
}

