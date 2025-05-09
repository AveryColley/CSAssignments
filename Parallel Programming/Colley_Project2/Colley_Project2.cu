//CS4370
//Parallel Programming for Many-Core GPUs
//Avery Colley
//Meilin Liu
//12/12/24
//Programming Assignment #2 - Tiled Matrix Multiplication
//Compiling command: nvcc Colley_Project2.cu -o matrix

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
	for(int row = 0; row < width; ++row) {
		for(int col = 0; col < width; ++col) {
			int sum = 0;
			for(int k = 0; k < width; ++k) {
				float a = M[row * width +k];
				float b = N[k * width + col];
				sum += a * b;
			}
			P[row * width + col] = sum;
		}
	}
}

__global__ void gpuMatrixMulti(int *d_M, int *d_N, int *d_P, int width) {
	const int TILE_WIDTH = 8;
	__shared__ float ds_M[TILE_WIDTH][TILE_WIDTH];
	__shared__ float ds_N[TILE_WIDTH][TILE_WIDTH];

	int bx = blockIdx.x;
	int by = blockIdx.y;
	int tx = threadIdx.x;
	int ty = threadIdx.y;

	int row = by * TILE_WIDTH + ty;
	int col = bx * TILE_WIDTH + tx;
	int pValue = 0;

	for(int m = 0; m < width / TILE_WIDTH; ++m) {
		ds_M[ty][tx] = d_M[row * width + m * TILE_WIDTH + tx];
		ds_N[ty][tx] = d_N[col + (m * TILE_WIDTH + ty) * width];
		__syncthreads();
		for(int k = 0; k < TILE_WIDTH; ++k) {
			pValue += ds_M[ty][k] * ds_N[k][tx];
		}
		__syncthreads();
	}
	d_P[row * width + col] = pValue;
}

int main() {
	int *A;
	int *B;
	int *C;
	int N = 4096;
	A = (int*) malloc(sizeof(int) * N * N);
	B = (int*) malloc(sizeof(int) * N * N);
	C = (int*) malloc(sizeof(int) * N * N);
	int init = 1325;
	for(int i = 0; i < N; i++) {
		for(int j = 0; j < N; j++) {
			init = 3125 * init % 6553;
			A[(i * N) + j] = (init - 1000) % 6553;
			B[(i * N) + j] = init % 251;
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

	const int BLOCK_SIZE = 8;
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