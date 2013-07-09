#!/usr/bin/env python

import pycuda.driver as cuda
# what is autoinit?
from pycuda.compiler import SourceModule

import numpy as np


kernel = SourceModule("""
	__global__ void noop(void) {
		// do nothing, just check if the code compiles and runs
	}
	""")

def dryrun():
	""" Set up stuff and call the device without doing any computations
	sanity check only """

	# I need to create a context first, I think
	gpu_noop = kernel.get_function("noop")
	gpu_noop()


def main():
	try:
		print "Attempting dryrun"
		dryrun()
		print "Dryrun successful"
	except Exception as e:
		print "Dryrun failed"
		print e
	

if __name__ == "__main__":
	main()
