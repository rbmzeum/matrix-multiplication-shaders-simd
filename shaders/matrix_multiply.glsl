#version 450
#pragma shader_stage(compute)

layout(local_size_x = 8, local_size_y = 4, local_size_z = 1) in;

layout(set = 0, binding = 0) buffer readonly MatrixA {
    int[1<<20] matrix_a;
};

layout(set = 0, binding = 1) buffer readonly MatrixB {
    int[1<<20] matrix_b;
};

layout(set = 0, binding = 2) buffer writeonly MatrixC {
    int[1<<20] matrix_c;
};

void main() {
    const uint row = gl_GlobalInvocationID.x * 1024;
    const uint col = gl_GlobalInvocationID.y;

    if(row >= 1024 * 1024 || col >= 1024) {
        return;
    }

    int sum = 0;

    for(uint i = 0; i < 1024; i += 8) {
	uint r = row + i;
	uint j = i * 1024 + col;
	sum += matrix_a[r] * matrix_b[j];
	sum += matrix_a[r + 1] * matrix_b[j + 1024];
	sum += matrix_a[r + 2] * matrix_b[j + 2048];
	sum += matrix_a[r + 3] * matrix_b[j + 3072];
	sum += matrix_a[r + 4] * matrix_b[j + 4096];
	sum += matrix_a[r + 5] * matrix_b[j + 5120];
	sum += matrix_a[r + 6] * matrix_b[j + 6144];
	sum += matrix_a[r + 7] * matrix_b[j + 7168];
    }

    matrix_c[row + col] = sum;
}
