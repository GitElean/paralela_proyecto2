#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>
#include <mpi.h>

#define MAX_KEY_LENGTH 16
#define BUFFER_SIZE 1024

// Prototipos de funciones
void encrypt(unsigned char *plaintext, unsigned char *key, unsigned char *ciphertext);
void decrypt(unsigned char *ciphertext, unsigned char *key, unsigned char *plaintext);
int tryKey(unsigned char *ciphertext, unsigned char *key, const char *searchString);
void my_memcpy(void *dest, void *src, size_t n);
int my_strstr(unsigned char *haystack, const char *needle);

int main(int argc, char **argv) {
    int rank, size;
    unsigned char key[MAX_KEY_LENGTH];
    unsigned char ciphertext[BUFFER_SIZE];
    unsigned char plaintext[BUFFER_SIZE];
    const char *searchString = "combinaciones";
    double startTime, endTime;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        FILE *file = fopen("message.txt", "r");
        if (!file) {
            printf("Error al abrir el archivo.\n");
            MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
        }
        fread(plaintext, sizeof(unsigned char), BUFFER_SIZE, file);
        fclose(file);

        if (my_strstr(plaintext, searchString)) {
            printf("El string '%s' está presente en el archivo de texto.\n", searchString);
        } else {
            printf("El string '%s' NO está presente en el archivo de texto.\n", searchString);
        }

        // Ciframos el texto con una llave de ejemplo
        unsigned char exampleKey[MAX_KEY_LENGTH] = "secretkey123456";
        encrypt(plaintext, exampleKey, ciphertext);
    }

    MPI_Bcast(ciphertext, BUFFER_SIZE, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);

    startTime = MPI_Wtime();

    unsigned long long i;
    for (i = rank; i < (1ULL << (8 * MAX_KEY_LENGTH)); i += size) {
        for (int j = 0; j < MAX_KEY_LENGTH; j++) {
            key[j] = (i >> (8 * j)) & 0xFF;
        }

        if (tryKey(ciphertext, key, searchString)) {
            printf("Proceso %d encontró la llave: %s\n", rank, key);
            break;
        }
    }

    endTime = MPI_Wtime();

    if (rank == 0) {
        printf("Tiempo total de ejecución: %f segundos.\n", endTime - startTime);
    }

    MPI_Finalize();
    return 0;
}

void encrypt(unsigned char *plaintext, unsigned char *key, unsigned char *ciphertext) {
    AES_KEY encryptKey;
    AES_set_encrypt_key(key, 128, &encryptKey);
    AES_encrypt(plaintext, ciphertext, &encryptKey);
}

void decrypt(unsigned char *ciphertext, unsigned char *key, unsigned char *plaintext) {
    AES_KEY decryptKey;
    AES_set_decrypt_key(key, 128, &decryptKey);
    AES_decrypt(ciphertext, plaintext, &decryptKey);
}

int tryKey(unsigned char *ciphertext, unsigned char *key, const char *searchString) {
    unsigned char decryptedText[BUFFER_SIZE];
    decrypt(ciphertext, key, decryptedText);
    return my_strstr(decryptedText, searchString);
}

void my_memcpy(void *dest, void *src, size_t n) {
    char *csrc = (char *)src;
    char *cdest = (char *)dest;
    for (int i = 0; i < n; i++) {
        cdest[i] = csrc[i];
    }
}

int my_strstr(unsigned char *haystack, const char *needle) {
    int len_haystack = strlen((char *)haystack);
    int len_needle = strlen(needle);
    for (int i = 0; i <= len_haystack - len_needle; i++) {
        if (strncmp((char *)(haystack + i), needle, len_needle) == 0) {
            return 1;
        }
    }
    return 0;
}
