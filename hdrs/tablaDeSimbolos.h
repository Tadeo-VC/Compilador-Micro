#ifndef TABLADESIMBOLOS_H
#define TABLADESIMBOLOS_H

#define TAMANIO_TS 100

#include <stdio.h>
#include <string.h>

enum tipoDeDato {NUMERICO = 0, CADENA = 1, ENTRADAVACIA = 2};

typedef struct {
    int valor;
    char* cadena;
    enum tipoDeDato tipo;
} exp;

// Tabla De Simbolos
typedef struct {
    char identificador[255];
    int esVariable; // bool
    exp valor;
} TS;

// - - - - - Rutinas Semanticas

// Declaraciones y Asignacion
int declararVariable(enum tipoDeDato tipo, char identificador[255]); // retorna la posicion del identificador para facilitar la declaracion de constante
void declararConstante(int posicionDelIdentificador);
void asignarValorAIdentificador(char identificador[255], exp expresion);

// Entrada / Salida
void imprimirExpresion(exp expresion);

// Expresiones
exp asignarCadenaAExpresion(char *cadena);
exp reducirExpresion(exp primaria, char operador, exp expresionAritmetica);
exp asignarValorAPrimaria(int valor);

// Otras 
void inicializarTablaDeSimbolos();
int posicionVacia(char identificador[255]);
int posicionDelIdentificador(char identificador[255]);
exp crearExpresionNumerica(int valor);
exp valorDeIdentificador(char identificador[255]);

#endif 
