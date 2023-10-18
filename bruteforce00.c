//bruteforce.c
//nota: el key usado es bastante pequenio, cuando sea random speedup variara

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <unistd.h>
#include <openssl/evp.h>    // Incluir las cabeceras de OpenSSL para DES

void decrypt(long key, char *ciph, int len) {
  EVP_CIPHER_CTX *ctx;
  int outlen1, outlen2;

  ctx = EVP_CIPHER_CTX_new();
  EVP_DecryptInit_ex(ctx, EVP_des_ecb(), NULL, (const unsigned char *)&key, NULL);
  EVP_DecryptUpdate(ctx, (unsigned char *)ciph, &outlen1, (unsigned char *)ciph, len);
  EVP_DecryptFinal_ex(ctx, (unsigned char *)ciph + outlen1, &outlen2);
  EVP_CIPHER_CTX_free(ctx);
}

void encrypt(long key, char *ciph, int len) {
  EVP_CIPHER_CTX *ctx;
  int outlen1, outlen2;

  ctx = EVP_CIPHER_CTX_new();
  EVP_EncryptInit_ex(ctx, EVP_des_ecb(), NULL, (const unsigned char *)&key, NULL);
  EVP_EncryptUpdate(ctx, (unsigned char *)ciph, &outlen1, (unsigned char *)ciph, len);
  EVP_EncryptFinal_ex(ctx, (unsigned char *)ciph + outlen1, &outlen2);
  EVP_CIPHER_CTX_free(ctx);
}
char search[] = " the ";
int tryKey(long key, char *ciph, int len){
  char temp[len+1];
  memcpy(temp, ciph, len);
  temp[len]=0;
  decrypt(key, temp, len);
  return strstr((char *)temp, search) != NULL;
}

unsigned char cipher[] = {108, 245, 65, 63, 125, 200, 150, 66, 17, 170, 207, 170, 34, 31, 70, 215, 0};
int main(int argc, char *argv[]){ //char **argv
  int N, id;
  long upper = (1L <<56); //upper bound DES keys 2^56
  long mylower, myupper;
  MPI_Status st;
  MPI_Request req;
  int flag;
  int ciphlen = strlen(cipher);
  MPI_Comm comm = MPI_COMM_WORLD;

  MPI_Init(NULL, NULL);
  MPI_Comm_size(comm, &N);
  MPI_Comm_rank(comm, &id);

  long range_per_node = upper / N;
  mylower = range_per_node * id;
  myupper = range_per_node * (id+1) -1;
  if(id == N-1){
    //compensar residuo
    myupper = upper;
  }

  long found = 0;
  int ready = 0;

  MPI_Irecv(&found, 1, MPI_LONG, MPI_ANY_SOURCE, MPI_ANY_TAG, comm, &req);

  for(long i = mylower; i<myupper; ++i){
    MPI_Test(&req, &ready, MPI_STATUS_IGNORE);
    if(ready)
      break;  //ya encontraron, salir

    if(tryKey(i, (char *)cipher, ciphlen)){
      found = i;
      for(int node=0; node<N; node++){
        MPI_Send(&found, 1, MPI_LONG, node, 0, MPI_COMM_WORLD);
      }
      break;
    }
  }

  if(id==0){
    MPI_Wait(&req, &st);
    decrypt(found, (char *)cipher, ciphlen);
    printf("%li %s\n", found, cipher);
  }

  MPI_Finalize();
}
