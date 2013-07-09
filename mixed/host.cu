#include<stdio.h>

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

	cudaMemcpy(a, a_, N * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(b, b_, N * sizeof(int), cudaMemcpyHostToDevice);

	vector_add<<<N,1>>>(a_, b_, out_);

	cudaMemcpy(out_, out, N * sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(a_);
	cudaFree(b_);
	cudaFree(c_);

	return 0;
}
