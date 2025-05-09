//CS4370
//Parallel Programming for Many-Core GPUs
//Avery Colley
//Meilin Liu
//12/11/24
//Programming Assignment #3Task2 - Work Efficient Parallel Prefix Sum
//Compiling command: nvcc Colley_Project3Task2.cu -o scan

#include <stdio.h>
#include <time.h>
#include <cuda.h>

void cpuPrefixScan(int* y, int* x, int N) {
	y[0] = x[0];
	for(int i = 1; i < N; i++) {
		y[i] = y[i - 1] + x[i];
	}
}

int verify(int *a, int *b, int size) {
	for(int i = 0; i < size; i++) {
		if(a[i] != b[i]) {
			printf("TEST FAILED at position %d\n", i);
			return 0;
		}
	}
	printf("TEST PASSED\n");
	return 1;
}



__global__ void gpuPrefixScan(int* y, int* x, int* b, int blockCount) {
	__shared__ int scan_array[2 * 128];

	unsigned int t = threadIdx.x;
	unsigned int start = 2 * blockIdx.x * blockDim.x;
	scan_array[t] = x[start + t];
	scan_array[blockDim.x + t] = x[start + blockDim.x + t];

	__syncthreads();

	//reduction step
	int stride = 1;
	int index;
	while(stride <= blockDim.x) {
		index = (threadIdx.x + 1) * stride * 2 - 1;
		if(index < 2 * blockDim.x) {
			scan_array[index] += scan_array[index - stride];
		}
		stride = stride * 2;

		__syncthreads();
	}

	//post scan step
	stride = blockDim.x / 2;
	while(stride > 0) {
		index = (threadIdx.x + 1) * stride * 2 - 1;
		if(index + stride < 2 * blockDim.x) {
			scan_array[index + stride] += scan_array[index];
		}
		stride = stride / 2;
		__syncthreads();
	}
	__syncthreads();

	y[start + t] = scan_array[t];
	y[start + blockDim.x + t] = scan_array[blockDim.x + t];
	b[blockIdx.x] = scan_array[(2 * blockDim.x) - 1];
	__syncthreads();

	//reduction step on block sums
	stride = 1;
	while(stride <= blockCount) {
		index = (threadIdx.x + 1) * stride * 2 - 1;
		if(index < 2 * blockCount) {
			b[index] += b[index - stride];
		}
		stride = stride * 2;

		__syncthreads();
	}

	//post scan step on block sums
	stride = blockCount / 2;
	while(stride > 0) {
		index = (threadIdx.x + 1) * stride * 2 - 1;
		if(index + stride < 2 * blockCount) {
			b[index + stride] += b[index];
		}
		stride = stride / 2;
		__syncthreads();
	}
	__syncthreads();


	__syncthreads();
	if(blockIdx.x != (blockCount - 1)) {
		y[((blockIdx.x + 1) * 2 * blockDim.x) + t] += b[blockIdx.x];
		y[((blockIdx.x + 1) * 2 * blockDim.x) + t + blockDim.x] += b[blockIdx.x];
	}
	__syncthreads();
}

int main() {
	int* A;
	int N = 2048;
	A = (int*) malloc(sizeof(int) * N);
	int init = 1325;
	for(int i = 0; i < N; i++) {
		init = (3125 * init) % 6553;
		A[i] = (init - 1000) % 97;
	}
	printf("Input array has %d elements\n", N);
	dim3 dimBlock(128);
	dim3 dimGrid(ceil((double) N / (2 * dimBlock.x)));
	printf("Using %d thread blocks of %d threads each\n", dimGrid.x, dimBlock.x);

	int* result = (int*) malloc(sizeof(int) * N);
	int* cpuOut = (int*) malloc(sizeof(int) * N);
	int* blockSum = (int*) malloc(sizeof(int) * dimGrid.x * 2);
	int* O = (int*) malloc(sizeof(int) * N);
	O[0] = A[0];

	int* a;
	int* out;
	int* bsum;
	cudaMalloc((void**)(&a), sizeof(int) * N);
	cudaMalloc((void**)(&out), sizeof(int) * N);
	cudaMalloc((void**)(&bsum), sizeof(int) * dimGrid.x * 2);
	cudaMemcpy(a, A, sizeof(int) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(out, O, sizeof(int) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(bsum, blockSum, sizeof(int) * dimGrid.x, cudaMemcpyHostToDevice);

	double cpuStartTime;
	double cpuTimeDifference;
	cpuStartTime = (double) clock();
	cpuPrefixScan(cpuOut, A, N);
	cpuTimeDifference = ((double) clock() - cpuStartTime) / CLOCKS_PER_SEC;

	double gpuStartTime;
	double gpuTimeDifference;
	gpuStartTime = (double) clock();
	gpuPrefixScan<<<dimGrid, dimBlock.x>>>(out, a, bsum, dimGrid.x);
	gpuTimeDifference = ((double) clock() - gpuStartTime) / CLOCKS_PER_SEC;

	cudaMemcpy(result, out, sizeof(int) * N, cudaMemcpyDeviceToHost);

	verify(cpuOut, result, N);
	printf("CPU runtime: %f seconds\n", cpuTimeDifference);
	printf("GPU runtime: %f seconds\n", gpuTimeDifference);

	printf("First 20 elements of the input array: ");
	for(int i = 0; i < 20; i++) {
		printf("%d", A[i]);
		printf("  ");
	}
	printf("\n");

	printf("First 20 elements of the CPU prefix scan array: ");
	for(int i = 0; i < 20; i++) {
		printf("%d", cpuOut[i]);
		printf("  ");
	}
	printf("\n");

	printf("First 20 elements of the GPU prefix scan array: ");
	for(int i = 0; i < 20; i++) {
		printf("%d", result[i]);
		printf("  ");
	}
	printf("\n");

	free(A);
	free(O);
	free(cpuOut);
	free(blockSum);
	cudaFree(a);
	cudaFree(out);
	cudaFree(bsum);
	return 0;
}