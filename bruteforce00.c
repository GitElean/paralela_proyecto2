#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>
#include <openssl/evp.h>
#include <mpi.h>

#define MAX_KEY_LENGTH 16
#define BUFFER_SIZE 1024

// Prototipos de funciones
int encrypt(unsigned char *plaintext, int plaintext_len, unsigned char *key, unsigned char *ciphertext);
int decrypt(unsigned char *ciphertext, int ciphertext_len, unsigned char *key, unsigned char *plaintext);
int tryKey(unsigned char *ciphertext, int ciphertext_len, unsigned char *key, const char *searchString);
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

    int ciphertext_len = 0;

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

        // Ciframos el texto con una llave de ejemplo más simple
        //unsigned char exampleKey[MAX_KEY_LENGTH] = "key";
        //ciphertext_len = encrypt(plaintext, strlen((char *)plaintext), exampleKey, ciphertext);
        //printf("Texto cifrado con la llave: %s\n", exampleKey);

		unsigned char testKey[MAX_KEY_LENGTH] = "18014398509481983L";
    	int test_ciphertext_len = encrypt(plaintext, strlen((char *)plaintext), testKey, ciphertext);
    	printf("Texto cifrado con la llave de prueba: %s\n", testKey);

    	// Descifrar inmediatamente
    	unsigned char test_decryptedText[BUFFER_SIZE];
    	int test_decrypted_len = decrypt(ciphertext, test_ciphertext_len, testKey, test_decryptedText);
    	test_decryptedText[test_decrypted_len] = '\0';  // Añadir terminador nulo

    	//printf("Texto descifrado inmediatamente con la llave de prueba %s: %s\n", testKey, test_decryptedText);
    	//fflush(stdout);

    	if (strcmp((char *)plaintext, (char *)test_decryptedText) == 0) {
        	//printf("El cifrado y descifrado con la llave de prueba funcionó correctamente.\n");
    	} else {
        	//printf("Hubo un error en el cifrado o descifrado con la llave de prueba.\n");
    	}

        // Verificar el cifrado y descifrado
        unsigned char decryptedText[BUFFER_SIZE];
        int decrypted_len = decrypt(ciphertext, ciphertext_len, testKey, decryptedText);
        decryptedText[decrypted_len] = '\0';  // Añadir terminador nulo
        if (my_strstr(decryptedText, searchString)) {
            printf("El descifrado fue exitoso.\n");
        } else {
            //printf("El descifrado falló.\n");
        }
    }

    MPI_Bcast(&ciphertext_len, 1, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(ciphertext, BUFFER_SIZE, MPI_UNSIGNED_CHAR, 0, MPI_COMM_WORLD);

    startTime = MPI_Wtime();

    unsigned long long i;
    int found = 0;

	strcpy((char *)key, "key");

    for (i = rank; i < (1ULL << (8 * 3)); i += size) {
        for (int j = 0; j < MAX_KEY_LENGTH; j++) {
            key[j] = (i >> (8 * j)) & 0xFF;
        }

        if (tryKey(ciphertext, ciphertext_len, key, searchString)) {
            printf("Proceso %d encontró la llave: %s\n", rank, key);
			fflush(stdout);
            found = 1;
            for (int p = 0; p < size; p++) {
                if (p != rank) {
                    MPI_Send(&found, 1, MPI_INT, p, 0, MPI_COMM_WORLD);
                }
            }
            break;
        }

        MPI_Iprobe(MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, &found, MPI_STATUS_IGNORE);
        if (found) {
            break;
        }
    }

    MPI_Barrier(MPI_COMM_WORLD);  // Asegurarse de que todos los procesos hayan terminado

    if (rank == 0) {
        endTime = MPI_Wtime();
        printf("Tiempo total de ejecución: %f segundos.\n", endTime - startTime);
    }

    MPI_Finalize();
    return 0;
}

int encrypt(unsigned char *plaintext, int plaintext_len, unsigned char *key, unsigned char *ciphertext) {
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    int len;
    int ciphertext_len;

    EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, NULL);
    EVP_EncryptUpdate(ctx, ciphertext, &len, plaintext, plaintext_len);
    ciphertext_len = len;

    EVP_EncryptFinal_ex(ctx, ciphertext + len, &len);
    ciphertext_len += len;

    EVP_CIPHER_CTX_free(ctx);
    return ciphertext_len;
}

int decrypt(unsigned char *ciphertext, int ciphertext_len, unsigned char *key, unsigned char *plaintext) {
    EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
    int len;
    int plaintext_len;

    EVP_DecryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, NULL);
    EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext, ciphertext_len);
    plaintext_len = len;

    EVP_DecryptFinal_ex(ctx, plaintext + len, &len);
    plaintext_len += len;

    EVP_CIPHER_CTX_free(ctx);
    return plaintext_len;
}

int tryKey(unsigned char *ciphertext, int ciphertext_len, unsigned char *key, const char *searchString) {
    unsigned char decryptedText[BUFFER_SIZE];
    int decrypted_len = decrypt(ciphertext, ciphertext_len, key, decryptedText);
    decryptedText[decrypted_len] = '\0';  // Añadir terminador nulo
    return my_strstr(decryptedText, searchString);
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
