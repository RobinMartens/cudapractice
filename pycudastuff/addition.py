import pycuda.driver as cuda
import pycuda.autoinit
from pycuda.compiler import SourceModule

import numpy as np
import scipy as sp

mod = SourceModule("""
	__global__ void add(int a, int b, int *c) {
		*c = a + b;
	}
	""")

def verbose_add():
	gpu_add = mod.get_function("add")

	x = 2
	y = 7
	z = 0

	# I personally don't like changing the type of identifiers...
	x = x.astype(np.float32)
	y = y.astype(np.float32)
	z = z.astype(np.float32)

	# move data to the device
	x_ = cuda.mem_alloc(x.nbytes)
	y_ = cuda.mem_alloc(y.nbytes)
	z_ = cuda.mem_alloc(z.nbytes)

	cuda.memcpy_htod(x_, x)
	cuda.memcpy_htod(y_, y)

	# do the calculations
	gpu_add(x_, y_, z_, block=(1,1,1)) # we just add two numbers so a single block is fine

	# get the results back to the RAM
	cuda.memcpy_dtoh(z, z_)

	print "%d + %d = %d" %(x,y,z)
	

def concise_add():
	raise ValueError("Under construction")
