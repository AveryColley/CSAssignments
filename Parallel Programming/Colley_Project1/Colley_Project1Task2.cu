//CS4370
//Parallel Programming for Many-Core GPUs
//Avery Colley
//Meilin Liu
//12/12/24
//Programming Assignment #1 - Basic Matrix Multiplication
//Compiling command: nvcc Colley_Project1Task2.cu -o matrixMult

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

void cpuMatrixMulti(int *M, int *N, int *P, int width) {
	for(int i = 0; i < width; ++i) {
		for(int j = 0; j < width; ++j) {
			int sum = 0;
			for(int k = 0; k < width; ++k) {
				int a = M[i * width + k];
				int b = N[k * width + j];
				sum += a * b;
			}
			P[i * width + j] = sum;
		}
	}
}

__global__ void gpuMatrixMulti(int *M, int *N, int *P, int width) {
	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int col = blockIdx.x * blockDim.x + threadIdx.x;

	if((row < width) && (col < width)) {
		int pValue = 0;
		for(int k = 0; k < width; ++k) {
			pValue += M[row * width + k] * N[k * width + col];
		}
		__syncthreads();
		P[row * width + col] = pValue;
	}
}

int main() {
	int *A;
	int *B;
	int *C;
	int N = 1024;
	A = (int*) malloc(sizeof(int) * N * N);
	B = (int*) malloc(sizeof(int) * N * N);
	C = (int*) malloc(sizeof(int) * N * N);
	int init = 1325;
	for(int i = 0; i < N; i++) {
		for(int j = 0; j < N; j++) {
			init = 3125 * init % 65536;
			A[(i * N) + j] = (init - 32768) / 6553;
			B[(i * N) + j] = init % 1000;
			C[(i * N) + j] = 0;
		}
	}
	printf("Input matrices have %d elements per row\n", N);

	int *a;
	int *b;
	int *c;
	int *result = (int*) malloc(sizeof(int) * N *N);

	cudaMalloc((void**)(&a), sizeof(int) * N * N);
	cudaMalloc((void**)(&b), sizeof(int) * N * N);
	cudaMalloc((void**)(&c), sizeof(int) * N * N);

	cudaMemcpy(a, A, sizeof(int) * N * N, cudaMemcpyHostToDevice);
	cudaMemcpy(b, B, sizeof(int) * N * N, cudaMemcpyHostToDevice);
	cudaMemcpy(c, C, sizeof(int) * N * N, cudaMemcpyHostToDevice);

	const int BLOCK_SIZE = 16;
	dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
	dim3 dimGrid(ceil((double) N / dimBlock.x), ceil((double) N / dimBlock.y));
	printf("Using %d thread blocks of %dx%d threads each\n", dimGrid.x * dimGrid.y, dimBlock.x, dimBlock.y);

	double cpuStartTime;
	double cpuTimeDifference;
	cpuStartTime = (double) clock();
	cpuMatrixMulti(A, B, C, N);
	cpuTimeDifference = ((double) clock() - cpuStartTime) / CLOCKS_PER_SEC;

	double gpuStartTime;
	double gpuTimeDifference;
	gpuStartTime = (double) clock();
	gpuMatrixMulti<<<dimGrid, dimBlock>>>(a, b, c, N);
	gpuTimeDifference = ((double) clock() - gpuStartTime) / CLOCKS_PER_SEC;

	cudaMemcpy(result, c, sizeof(int) * N * N, cudaMemcpyDeviceToHost);
	verify(C, result, N * N);
	printf("CPU runtime: %f seconds\n", cpuTimeDifference);
	printf("GPU runtime: %f seconds\n", gpuTimeDifference);

	printf("First row of CPU result matrix: [");
	for(int i = 0; i < N; i++) {
		printf("%d", C[i]);
		printf(" ");
	}
	printf("]\n");

	printf("First row of GPU result matrix: [");
	for(int i = 0; i < N; i++) {
		printf("%d", result[i]);
		printf(" ");
	}
	printf("]\n");

	free(A);
	free(B);
	free(C);
	free(result);
	cudaFree(a);
	cudaFree(b);
	cudaFree(c);
	return 0;
}