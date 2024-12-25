#ifndef TABLADESIMBOLOS_H
#define TABLADESIMBOLOS_H

#define TAMANIO_TS 100

enum tipoDeDato {NUMERICO = 0, CADENA = 1, ENTRADAVACIA = 2};

typedef struct {
    int valorReducido;
    char* cadena;
    enum tipoDeDato tipo;
} exp;

typedef struct {
    exp expresion;
    nodoExp sgteExpresion;
} nodoExp; // FIFO

typedef struct {
    char identificador[255];
    nodoID *sgteIdentificador;
} nodoID; // FIFO

// Rutinas Semanticas

void declararConstante(char identificador[255]);
void declararVariable(char *tipo, char identificador[255]);
void asignarValorAIdentificador(char identificador[255], exp expresion);

void escribir(nodoExp *expresiones);
void leer(nodoID *identificadores);

exp asignarNumericoAExpresion(exp expresionAritmetica);
exp asignarCadenaAExpresion(char *cadena);
exp reducirExpresion(exp primaria, char operador, exp expresionAritmetica);
exp reducirPrimaria(exp primaria);
exp asignarValorAPrimaria(int valor);

// Otras funciones de la tabla 

#endif 
