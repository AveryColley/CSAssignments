//CS4370
//Parallel Programming for Many-Core GPUs
//Avery Colley
//Meilin Liu
//12/11/24
//Programming Assignment #3Task1 - Work Efficient Parallel Reduction
//Compiling command: nvcc Colley_Project3Task1.cu -o sum

#include <stdio.h>
#include <time.h>
#include <cuda.h>

int cpuSumReduction(int* x, int N) {
	for(int i = 1; i < N; i++) {
		x[0] = x[0] + x[i];
	}
	int overallSum = x[0];
	return overallSum;
}

int verify(int a, int b) {
	if(a == b) {
		printf("TEST PASSED\n");
		return 1;
	}
	printf("TEST FAILED\n");
	return 0;
}

void makeBlockArray(int* input, int* output, int N) {
	int j = 0;
	for(int i = 0; i < N; i = i + 1024) {
		output[j] = input[i];
		j++;
	}
}


__global__ void gpuSumReduction(unsigned int* input) {
	__shared__ int partialSum[2 * 512];

	unsigned int tx = threadIdx.x;
	unsigned int start = 2 * blockIdx.x * blockDim.x;
	partialSum[tx] = input[start + tx];
	partialSum[blockDim.x + tx] = input[start + blockDim.x + tx];

	for(unsigned int stride = blockDim.x; stride > 0; stride /= 2) {
		if(tx < stride) {
			partialSum[tx] += partialSum[tx + stride];
		}
		__syncthreads();
	}
	__syncthreads();

	if(tx == 0) {
		input[2 * 512 * blockIdx.x] = partialSum[tx];
	}
}

int main() {
	int* A;
	int N = 131072;
	A = (int*) malloc(sizeof(int) * N);
	int init = 1325;
	for(int i = 0; i < N; i++) {
		init = (3125 * init) % 6553;
		A[i] = (init - 1000) % 97;
	}
	int firstInput = A[0];
	printf("Input array has %d elements\n", N);
	dim3 dimBlock(512);
	dim3 dimGrid(ceil((double) N / (2 * dimBlock.x)));
	printf("Using %d thread blocks of %d threads each\n", dimGrid.x, dimBlock.x);

	int* result = (int*) malloc(sizeof(int) * N);
	int* B = (int*) malloc(sizeof(int) * (N / (dimBlock.x * 2)));
	int* gpuFinal = (int*) malloc(sizeof(int) * (N / (dimBlock.x * 2)));

	unsigned int* a;
	unsigned int* b;
	cudaMalloc((void**)(&a), sizeof(int) * N);
	cudaMalloc((void**)(&b), sizeof(int) * (N / (dimBlock.x * 2)));
	cudaMemcpy(a, A, sizeof(int) * N, cudaMemcpyHostToDevice);

	double cpuStartTime;
	double cpuTimeDifference;
	cpuStartTime = (double) clock();
	int cpuFinal = cpuSumReduction(A, N);
	cpuTimeDifference = ((double) clock() - cpuStartTime) / CLOCKS_PER_SEC;

	double gpuComputationTime = 0;
	double gpuStartTime;
	double gpuTimeDifference;
	gpuStartTime = (double) clock();
	gpuSumReduction<<<dimGrid, dimBlock.x>>>(a);
	gpuTimeDifference = ((double) clock() - gpuStartTime) / CLOCKS_PER_SEC;
	gpuComputationTime += gpuTimeDifference;
	cudaMemcpy(result, a, sizeof(int) * N, cudaMemcpyDeviceToHost);
	makeBlockArray(result, B, N);
	cudaMemcpy(b, B, sizeof(int) * (N / (dimBlock.x * 2)), cudaMemcpyHostToDevice);
	gpuStartTime = (double) clock();
	gpuSumReduction<<<1, dimBlock.x>>>(b);
	gpuTimeDifference = ((double) clock() - gpuStartTime) / CLOCKS_PER_SEC;
	gpuComputationTime += gpuTimeDifference;

	cudaMemcpy(gpuFinal, b, sizeof(int) * (N / (dimBlock.x * 2)), cudaMemcpyDeviceToHost);

	verify(cpuFinal, gpuFinal[0]);
	printf("CPU runtime: %f seconds\n", cpuTimeDifference);
	printf("GPU runtime: %f seconds\n", gpuComputationTime);

	printf("First 20 elements of the input array: %d ", firstInput);
	for(int i = 1; i < 20; i++) {
		printf("%d", A[i]);
		printf("  ");
	}
	printf("\n");

	printf("First 20 elements of the CPU parallel reduction array: ");
	for(int i = 0; i < 20; i++) {
		printf("%d", A[i]);
		printf("  ");
	}
	printf("\n");

	printf("First 20 elements of the GPU parallel reduction array: ");
	for(int i = 0; i < 20; i++) {
		printf("%d", gpuFinal[i]);
		printf("  ");
	}
	printf("\n");

	free(A);
	free(B);
	free(result);
	free(gpuFinal);
	cudaFree(a);
	cudaFree(b);
	return 0;
}