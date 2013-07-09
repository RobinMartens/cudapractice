#include <stdio.h>

#include "kernels.h"

#define N 10

int main(int argc, char **argv) {

	int a[N];
	int b[N];
	int out[N];

	// generate toydata
	for(int i=0; i < N; i++){
		a[i] = 2*i;
		b[i] = i*i;
	}

	int *a_;
	int *b_;
	int *out_;

	cudaMalloc((void**)&a_, N * sizeof(int));
	cudaMalloc((void**)&b_, N * sizeof(int));
	cudaMalloc((void**)&out_, N * sizeof(int));

	cudaMemcpy(a_, a, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(b_, b, N * sizeof(int), cudaMemcpyHostToDevice);

	vector_add<<<N,1>>>(a_, b_, out_, N);

	cudaMemcpy(out, out_, N * sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(a_);
	cudaFree(b_);
	cudaFree(out_);

	for(int i=0; i < N; i++){
		printf("%d + %d = %d\n", a[i], b[i], out[i]);
	}

	return 0;
}
