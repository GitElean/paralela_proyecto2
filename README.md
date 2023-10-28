# paralela_proyecto2

## Compilación
mpicc -o target bruteforce00.c -lssl -lcrypto

## Ejecución
mpirun -np nProcesos ./target
