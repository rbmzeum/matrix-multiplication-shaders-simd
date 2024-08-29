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
    const uint row = gl_GlobalInvocationID.x;
    const uint col = gl_GlobalInvocationID.y;

    if(row >= 1024 || col >= 1024) {
        return;
    }

    int sum = 0;
/*    for(uint i = 0; i < 1024; i++) {
        sum += matrix_a[row * 1024 + i] * matrix_b[i * 1024 + col];
    }*/
    for(uint i = 0; i < 1024; i += 8) {
	sum += matrix_a[row * 1024 + i] * matrix_b[i * 1024 + col];
	sum += matrix_a[row * 1024 + i + 1] * matrix_b[(i+1) * 1024 + col];
	sum += matrix_a[row * 1024 + i + 2] * matrix_b[(i+2) * 1024 + col];
	sum += matrix_a[row * 1024 + i + 3] * matrix_b[(i+3) * 1024 + col];
	sum += matrix_a[row * 1024 + i + 4] * matrix_b[(i+4) * 1024 + col];
	sum += matrix_a[row * 1024 + i + 5] * matrix_b[(i+5) * 1024 + col];
	sum += matrix_a[row * 1024 + i + 6] * matrix_b[(i+6) * 1024 + col];
	sum += matrix_a[row * 1024 + i + 7] * matrix_b[(i+7) * 1024 + col];
    }

    matrix_c[row * 1024 + col] = sum;
}
