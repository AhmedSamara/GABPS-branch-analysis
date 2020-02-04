# See LICENSE.txt for license details.

CXX_FLAGS += -std=c++11 -g -O3 -Wall
PAR_FLAG = -fopenmp

ifneq (,$(findstring icpc,$(CXX)))
	PAR_FLAG = -openmp
endif

ifneq (,$(findstring sunCC,$(CXX)))
	CXX_FLAGS = -std=c++11 -xO3 -m64 -xtarget=native
	PAR_FLAG = -xopenmp
endif

ifneq ($(SERIAL), 1)
	CXX_FLAGS += $(PAR_FLAG)
endif

KERNELS = bc bfs cc cc_sv pr sssp tc
SUITE = $(KERNELS) converter

.PHONY: all
all: $(SUITE)

% : src/%.cc src/*.h
	$(CXX) $(CXX_FLAGS) -I ../../include $< -o $@

# Testing
include test/test.mk

# Benchmark Automation
include benchmark/bench.mk

# alt:  ./ run - sniper -- / bin / ls
run:
	../../run-sniper -v -n 1 -c gainestown --roi -- ./bfs -u 10


.PHONY: clean
clean:
	rm -f $(SUITE) test/out/*
