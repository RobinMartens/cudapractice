#include "/home/robin/src/cudapractice/support/common/book.h"

#define N 10

__global__ void add( int *a, int *b, int *c);

int main( void ) {
	int a[N];
	int b[N];
	int c[N];

	int *dev_a;
	int *dev_b;
	int *dev_c;

	// allocate the memory on the GPU
	HANDLE_ERROR( cudaMalloc( (void**) &dev_a, N * sizeof(int) ) );
	HANDLE_ERROR( cudaMalloc( (void**) &dev_b, N * sizeof(int) ) );
	HANDLE_ERROR( cudaMalloc( (void**) &dev_c, N * sizeof(int) ) );

	// fill the arrays 'a' and 'b' on the CPU
	for (int i=0; i<N; i++) {
		a[i] = -i;
		b[i] = i * i;
	}

	// copy teh arrays 'a' and 'b' to the GPU
	HANDLE_ERROR( cudaMemcpy( dev_a, a, N * sizeof(int), cudaMemcpyHostToDevice) );
	HANDLE_ERROR( cudaMemcpy( dev_b, b, N * sizeof(int), cudaMemcpyHostToDevice) );

	add<<<N,1>>>( dev_a, dev_b, dev_c );

	// copy the array 'c' back from teh GPU to the CPU
	HANDLE_ERROR( cudaMemcpy( c, dev_c, N * sizeof(int), cudaMemcpyDeviceToHost ) );

	// display the results
	for (int i=0; i<N; i++) {
		printf( "%d + %d = %d\n", a[i], b[i], c[i] );
	}

	// free the memory allocated ont he GPU
	cudaFree( dev_a );
	cudaFree( dev_b );
	cudaFree( dev_c );


	return 0;
}

__global__ void add( int *a, int *b, int *c ) {
	int tid = blockIdx.x;
	if (tid < N) {
		c[tid] = a[tid] + b[tid];
	}
}
