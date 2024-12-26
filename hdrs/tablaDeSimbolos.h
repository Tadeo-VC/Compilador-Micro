#ifndef TABLADESIMBOLOS_H
#define TABLADESIMBOLOS_H

#define TAMANIO_TS 100

enum tipoDeDato {INT = 0, STRING = 1, ENTRADAVACIA = 2};

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
int declararVariable(enum tipoDeDato tipo, char identificador[255]); // retorna la posicion del identificador para facilitar la declaracion de constante
void declararConstante(int posicionDelIdentificador);
void asignarValorAIdentificador(char identificador[255], exp expresion);

// Entrada / Salida
void escribir(nodoExp *expresiones);
void leer(nodoID *identificadores);

// Expresiones
exp asignarCadenaAExpresion(char *cadena);
exp reducirExpresion(exp primaria, char operador, exp expresionAritmetica);
exp asignarValorAPrimaria(float valor);

// Otras 
void inicializarTablaDeSimbolos();
int posicionVacia();
int posicionDelIdentificador(char identificador[255]);
exp crearExpresionNumerica(float valor);
exp valorDeIdentificador(char identificador[255]);

#endif 
