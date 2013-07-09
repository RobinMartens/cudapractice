CUDA='nvcc'
SOURCES=$(wildcard src/**/*.cu src/*.c)

build:
	$(CUDA) $(SOURCES)

clean:
	rm bin/$(OBJECTS)		
