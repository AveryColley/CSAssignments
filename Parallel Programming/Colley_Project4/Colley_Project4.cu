//CS4370
//Parallel Programming for Many-Core GPUs
//Avery Colley
//Meilin Liu
//12/6/24
//Programming Assignment #4 -- Histogram
//Compiling command: nvcc Colley_Project4.cu -o histogram -arch=sm_30

#include <stdio.h>
#include <time.h>
#include <cuda.h>

int verify(int *a, int *b, int size) {
	for(int i = 0; i < size; i++) {
		if(a[i] != b[i]) {
			printf("TEST FAILED\n");
			return 0;
		}
	}
	printf("TEST PASSED\n");
	return 1;
}

void compute_histogram(int *input, int size, int* output) {
		for(int i = 0; i < 256; i++) {
			output[i] = 0;
		}
		for(int i = 0; i < size; i++) {
			output[input[i]]++;
		}
}

__global__ void atomic_histogram_kernel(unsigned int *buffer, long size, int *histo) {
	int i = threadIdx.x + blockIdx.x * blockDim.x;
	int stride = blockDim.x * gridDim.x;
	while (i < size) {
		atomicAdd(&(histo[buffer[i]]), 1);
		i += stride;
	}
}

__global__ void shared_histogram_kernel(unsigned int *buffer, long size, int *histo) {
	__shared__ unsigned int histo_private[256];
	if(threadIdx.x < 256) {
		histo_private[threadIdx.x] = 0;
	}
	__syncthreads();

	int i = threadIdx.x + blockIdx.x * blockDim.x;
	int stride = blockDim.x * gridDim.x;
	while( i < size) {
		atomicAdd(&(histo_private[buffer[i]]), 1);
		i += stride;
	}

	__syncthreads();
	if(threadIdx.x < 256) {
		atomicAdd(&(histo[threadIdx.x]), histo_private[threadIdx.x]);
	}
}

int main() {
	int *A;
	int N = 131072;
	A = (int*) malloc(sizeof(int) * N );
	int init = 1325;
	for(int i = 0; i < N; i++) {
		init = 3125 * init % 65537;
		A[i] = init % 256;
	}
	printf("Input array has %d elements\n", N);

	int* H;
	H = (int*) malloc(sizeof(int) * 256);
	for(int i = 0; i < 256; i++) {
		H[i] = 0;
	}

	int *output = (int*) malloc(sizeof(int) * 256);


	unsigned int* dev_a;
	int* histo;
	int* result = (int*) malloc(sizeof(int) * 256);
	cudaMalloc((void**)(&dev_a), sizeof(int) * N);
	cudaMalloc((void**)(&histo), sizeof(int) * 256);
	cudaMemcpy(dev_a, A, sizeof(int) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(histo, H, sizeof(int) * 256, cudaMemcpyHostToDevice);
	const int BLOCK_SIZE = 512;
	int blockCount = ceil (N / double(BLOCK_SIZE));
	printf("Using %d thread blocks of %d threads each\n", blockCount, BLOCK_SIZE);



	double cpuStartTime;
	double cpuTimeDifference;
	cpuStartTime = (double) clock();
	compute_histogram(A, N, output);
	cpuTimeDifference = ((double) clock() - cpuStartTime) / CLOCKS_PER_SEC;

	double gpuStartTime;
	double gpuTimeDifference;
	gpuStartTime = (double) clock();
	shared_histogram_kernel<<<blockCount, BLOCK_SIZE>>>(dev_a, N, histo);
	gpuTimeDifference = ((double) clock() - gpuStartTime) / CLOCKS_PER_SEC;

	cudaMemcpy(result, histo, sizeof(int) * 256, cudaMemcpyDeviceToHost);
	verify(result, output, 256);
	printf("CPU runtime: %f seconds\n", cpuTimeDifference);
	printf("GPU runtime: %f seconds\n", gpuTimeDifference);

	printf("First 10 elements of the input array: ");
	for(int i = 0; i < 10; i++) {
		printf("%d", A[i]);
		printf("  ");
	}
	printf("\n");

	printf("First 10 elements of the CPU histogram: ");
	for(int i = 0; i < 10; i++) {
		printf("%d", output[i]);
		printf("  ");
	}
	printf("\n");

	printf("First 10 elements of the GPU histogram: ");
	for(int i = 0; i < 10; i++) {
		printf("%d", result[i]);
		printf("  ");
	}
	printf("\n");

	free(A);
	free(result);
	free(output);
	cudaFree(dev_a);
	cudaFree(histo);
	return 0;
}