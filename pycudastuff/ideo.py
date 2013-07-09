#!/usr/bin/env python

import pycuda.driver as cuda
# what is autoinit?
import pycuda.autoinit
from pycuda.compiler import SourceModule

import numpy as np


kernel = SourceModule("""
	__global__ void noop(void) {
		// do nothing, just check if the code compiles and runs
	}

    __global__ void add(int a, int b, int *c) {
        c* = a + b;
    }
	""")


def dryrun():
	""" Set up stuff and call the device without doing any computations
	sanity check only """

	# I need to create a context first, I think
	gpu_noop = kernel.get_function("noop")
	gpu_noop(block=(1,1,1))


def addition():
	""" Add two numbers on the GPU """

	x = np.int32(2)
	y = np.int32(7)
	z = np.int32(0)

	# move data to the device
	x_ = cuda.mem_alloc(x.nbytes)
	y_ = cuda.mem_alloc(y.nbytes)
	z_ = cuda.mem_alloc(z.nbytes)

	cuda.memcpy_htod(x_, x)
	cuda.memcpy_htod(y_, y)

	# do the calculations
	gpu_add(x_, y_, z_, block=(1,1,1)) 

	# get the results back to the RAM
	cuda.memcpy_dtoh(z, z_)

	print "%d + %d = %d" %(x,y,z)


def main():

	functions = {
		"dryrun" : dryrun,
	}
	
	for cur in functions:
		try:
			print "Attempting %s" % cur
			functions[cur]()
			print "%s successful" % cur
		except Exception as e:
			print "%s failed" % cur
			print e


if __name__ == "__main__":
	main()
