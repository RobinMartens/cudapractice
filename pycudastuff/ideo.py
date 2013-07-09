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
	""")


def dryrun():
	""" Set up stuff and call the device without doing any computations
	sanity check only """

	# I need to create a context first, I think
	gpu_noop = kernel.get_function("noop")
	gpu_noop(block=(1,1,1))


def addition():
	""" Add two numbers on the GPU """



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
