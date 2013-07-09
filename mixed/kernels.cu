// this is dull!
__global__ void vector_add(int *a, int *b, int *out, int max) {
	int tid = blockIdx.x; 
	if(tid < max) {
		out[tid] = a[tid] + b[tid];
	}
}

__global__ void intmap(int *a, int *out, int (*f)(int x), int max){
	int tid = blockIdx.x + blockIdx.x * blockDim.x;
	if(tid < max) {
		out[tid] = f(a[tid]);
	}
}

__device__ int increment(int a){
	return a+1;
}
