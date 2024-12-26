#ifndef TABLADESIMBOLOS_H
#define TABLADESIMBOLOS_H

#define TAMANIO_TS 100

enum tipoDeDato {NUMERICO = 0, CADENA = 1, ENTRADAVACIA = 2};

typedef struct {
    float valor;
    char* cadena;
    enum tipoDeDato tipo;
} exp;

// Tabla De Simbolos
typedef struct {
    char identificador[255];
    int esVariable; // bool
    exp valor;
} TS;

// Listas

typedef struct {
    exp expresion;
    nodoExp sgteExpresion;
} nodoExp; // FIFO

typedef struct {
    char identificador[255];
    nodoID *sgteIdentificador;
} nodoID; // FIFO

// - - - - - Rutinas Semanticas

// Declaraciones y Asignacion
void declararVariableInt(char identificador[255]);
void declararConstanteInt(char identificador[255]);
void declararVariableString(char identificador[255]);
void declararConstanteString(char identificador[255]);
void asignarValorAIdentificador(char identificador[255], exp expresion);

// Entrada / Salida
void escribir(nodoExp *expresiones);
void leer(nodoID *identificadores);

// Expresiones
exp asignarCadenaAExpresion(char *cadena);
exp reducirExpresion(exp primaria, char operador, exp expresionAritmetica);
exp asignarValorAPrimaria(float valor);

// Otras 
exp crearExpresionNumerica(float valor);
exp valorDeIdentificador(char identificador[255]);

#endif 
