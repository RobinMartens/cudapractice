int main( void ) {
    // capture the start time
    cudaEvent_t start;
    cudaEvent_t stop;
    HANDLE_ERROR( cudaEventCreate( &start ) );
    HANDLE_ERROR( cudaEventCreate( &stop) );
    HANDLE_ERROR( cudaEventRecord( start, 0 ) );

	CPUBitmap bitmap ( DIM, DIM);
	unsigned char *dev_bitmap;

	// allocate memory on teh GPU for the output bitmap
	HANDLE_ERROR( cudaMalloc( (void**) &dev_bitmap, bitmap.image_size() ) );
	
	Sphere *temp_s = (Sphere*)malloc( sizeof(Sphere) * SPHERES );
	for (int i=0; i<SPHERES; i++) {
		temp_s[i].r = rnd( 1.0f );
		temp_s[i].g = rnd( 1.0f );
		temp_s[i].b = rnd( 1.0f );
		temp_s[i].x = rnd( 1000.0f ) - 500;
		temp_s[i].x = rnd( 1000.0f ) - 500;
		temp_s[i].x = rnd( 1000.0f ) - 500;
		temp_s[i].radius = rnd( 100.0f ) + 20;
	}
	handle_error( cudaMemcpyToSymbol( s, temp_s, sizeof(Sphere) * SPHERES) );
	free( temp_s);

	// generate a bitmap from our sphere data
	dim3 grids(DIM/16,DIM/16);
	dim3 threads(16,16);

