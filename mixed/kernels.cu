__global__ void vector_add(int *a, int *b, int *out, int max) {
	int tid = threadIdx.x; 
	if(tid < max) {
		out[tid] = a[tid] + b[tid];
	}
}
