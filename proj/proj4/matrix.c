#include "matrix.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

// Include SSE intrinsics
#if defined(_MSC_VER)
#include <intrin.h>
#elif defined(__GNUC__) && (defined(__x86_64__) || defined(__i386__))
#include <immintrin.h>
#include <x86intrin.h>
#endif

/* Below are some intel intrinsics that might be useful
 * void _mm256_storeu_pd (double * mem_addr, __m256d a)
 * __m256d _mm256_set1_pd (double a)
 * __m256d _mm256_set_pd (double e3, double e2, double e1, double e0)
 * __m256d _mm256_loadu_pd (double const * mem_addr)
 * __m256d _mm256_add_pd (__m256d a, __m256d b)
 * __m256d _mm256_sub_pd (__m256d a, __m256d b)
 * __m256d _mm256_fmadd_pd (__m256d a, __m256d b, __m256d c)
 * __m256d _mm256_mul_pd (__m256d a, __m256d b)
 * __m256d _mm256_cmp_pd (__m256d a, __m256d b, const int imm8)
 * __m256d _mm256_and_pd (__m256d a, __m256d b)
 * __m256d _mm256_max_pd (__m256d a, __m256d b)
*/

/* Generates a random double between low and high */
double rand_double(double low, double high) {
    double range = (high - low);
    double div = RAND_MAX / range;
    return low + (rand() / div);
}

/* Generates a random matrix */
void rand_matrix(matrix *result, unsigned int seed, double low, double high) {
    srand(seed);
    for (int i = 0; i < result->rows; i++) {
        for (int j = 0; j < result->cols; j++) {
            set(result, i, j, rand_double(low, high));
        }
    }
}

/*
 * Allocates space for a matrix struct pointed to by the double pointer mat with
 * `rows` rows and `cols` columns. You should also allocate memory for the data array
 * and initialize all entries to be zeros. `parent` should be set to NULL to indicate that
 * this matrix is not a slice. You should also set `ref_cnt` to 1.
 * You should return -1 if either `rows` or `cols` or both have invalid values, or if any
 * call to allocate memory in this function fails. Return 0 upon success.
 */
int allocate_matrix(matrix **mat, int rows, int cols) {
    if (rows <= 0 || cols <= 0) 
        return -1;

    *mat = (matrix*) malloc(sizeof(matrix));
    if ((*mat) == NULL) {
        return -1;
    }
    (*mat)->data = (double *) calloc(rows * cols, sizeof(double));
    if ((*mat)->data == NULL) {
        free(*mat); 
        return -1;
    }
    (*mat)->rows = rows;
    (*mat)->cols = cols;
    (*mat)->ref_cnt = 1;
    (*mat)->parent = NULL;

    return 0;
}

/*
 * Allocates space for a matrix struct pointed to by `mat` with `rows` rows and `cols` columns.
 * Its data should point to the `offset`th entry of `from`'s data (you do not need to allocate memory)
 * for the data field. `parent` should be set to `from` to indicate this matrix is a slice of `from`.
 * You should return -1 if either `rows` or `cols` or both are non-positive or if any
 * call to allocate memory in this function fails. Return 0 upon success.
 */
int allocate_matrix_ref(matrix **mat, matrix *from, int offset, int rows, int cols) {
    if (rows <= 0 || cols <= 0) 
        return -1;

    (*mat) = (matrix*) malloc(sizeof(matrix));
    if ((*mat) == NULL) 
        return -1;
    (*mat)->data = from->data + offset;
    (*mat)->rows = rows;
    (*mat)->cols = cols;
    (*mat)->ref_cnt = 1;
    (*mat)->parent = from;
    from->ref_cnt++;

    return 0;
}

/*
 * You need to make sure that you only free `mat->data` if `mat` is not a slice and has no existing slices,
 * or if `mat` is the last existing slice of its parent matrix and its parent matrix has no other references
 * (including itself). You cannot assume that mat is not NULL.
 */
void deallocate_matrix(matrix *mat) {
    if (mat == NULL)
        return;

    mat->ref_cnt--;
    if (mat->parent == NULL) {
        if (mat->ref_cnt == 0) {
            free(mat->data);
            free(mat);
        }
    } else {
        mat->parent->ref_cnt--;
        if (mat->ref_cnt == 0) {
            if (mat->parent->ref_cnt == 0) {
                mat->parent->ref_cnt += 1;
                deallocate_matrix(mat->parent);
            } 
            free(mat);
        }
    }
}

/*
 * Returns the double value of the matrix at the given row and column.
 * You may assume `row` and `col` are valid.
 */
double get(matrix *mat, int row, int col) {
    return mat->data[row * mat->cols + col];
}

/*
 * Sets the value at the given row and column to val. You may assume `row` and
 * `col` are valid
 */
void set(matrix *mat, int row, int col, double val) {
    mat->data[row * mat->cols + col] = val;
}

/*
 * Sets all entries in mat to val
 */
void fill_matrix(matrix *mat, double val) {
    for (int i = mat->rows * mat->cols - 1; i >= 0; i--) 
        mat->data[i] = val;
}

/*
 * Store the result of adding mat1 and mat2 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int add_matrix(matrix *result, matrix *mat1, matrix *mat2) {
    if (mat1->rows != mat2->rows || mat1->cols != mat2->cols)
        return 1;
    if (result->rows != mat1->rows || result->cols != mat1->cols)
        return 1;
    for (int i = mat1->rows * mat1->cols - 1; i >= 0; i--) 
        result->data[i] = mat1->data[i] + mat2->data[i];
    return 0;
}    


/*
 * Store the result of subtracting mat2 from mat1 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int sub_matrix(matrix *result, matrix *mat1, matrix *mat2) {
    if (mat1->rows != mat2->rows || mat1->cols != mat2->cols)
        return 1;
    if (result->rows != mat1->rows || result->cols != mat1->cols)
        return 1;
    for (int i = mat1->rows * mat1->cols - 1; i >= 0; i--) 
        result->data[i] = mat1->data[i] - mat2->data[i];
    return 0;
}

/*
 * Store the result of multiplying mat1 and mat2 to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 * Remember that matrix multiplication is not the same as multiplying individual elements.
 */
int mul_matrix(matrix *result, matrix *mat1, matrix *mat2) {
    if (mat1->cols != mat2->rows)
        return 1;
    if (result->rows != mat1->rows || result->cols != mat2->cols)
        return 1;

    for (int i = 0; i < mat1->rows; i++) {
        for (int j = 0; j < mat2->cols; j++) {
            set(result, i, j, 0);
            for (int k = 0; k < mat1->cols; k++) {
                set(result, i, j, get(result, i, j) 
                    + get(mat1, i, k) * get(mat2, k, j));
            }
        }
    }
    return 0;
}

/*
 * Store the result of raising mat to the (pow)th power to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 * Remember that pow is defined with matrix multiplication, not element-wise multiplication.
 */
int pow_matrix(matrix *result, matrix *mat, int pow) {
    if (pow < 0 || mat->rows != mat->cols)  
        return 2;
    if (result->rows != mat->rows || result->cols != mat->cols)
        return 2;
    
    fill_matrix(result, 0);
    for (int i = 0; i < result->rows; i++) 
        set(result, i, i, 1);

    matrix *t;
    allocate_matrix(&t, result->rows, result->cols);
    while (pow--) {
        for (int i = result->rows * result->cols - 1; i >= 0; i--) 
            t->data[i] = result->data[i];
        mul_matrix(result, t, mat);
    }
    deallocate_matrix(t);
    return 0;
}

/*
 * Store the result of element-wise negating mat's entries to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int neg_matrix(matrix *result, matrix *mat) {
    if (result->rows != mat->rows || result->cols != mat->cols)
        return 1;
    for (int i = mat->rows * mat->cols - 1; i >= 0; i--) 
        result->data[i] = -mat->data[i];
    return 0;
}

/*
 * Store the result of taking the absolute value element-wise to `result`.
 * Return 0 upon success and a nonzero value upon failure.
 */
int abs_matrix(matrix *result, matrix *mat) {
    if (result->rows != mat->rows || result->cols != mat->cols)
        return 1;
    for (int i = mat->rows * mat->cols - 1; i >= 0; i--) 
        result->data[i] = mat->data[i] < 0? -mat->data[i]: mat->data[i];
    return 0;
}
