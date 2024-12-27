#include "../hdrs/tablaDeSimbolos.h"
#include <stdio.h>
#include <string.h>

TS tablaDeSimbolos[TAMANIO_TS];

// Declaraciones y Asignaciones

int declararVariable(enum tipoDeDato tipo, char identificador[255])
{
    int nuevaPosicion = posicionVacia(identificador);
    strcpy(tablaDeSimbolos[nuevaPosicion].identificador, identificador);
    tablaDeSimbolos[nuevaPosicion].esVariable = 0;

    if(tipo == INT)
    {
        tablaDeSimbolos[nuevaPosicion].valor.tipo = INT;
    }
    if(tipo == STRING)
    {
        tablaDeSimbolos[nuevaPosicion].valor.tipo = STRING;
    }

    return nuevaPosicion;
}
void declararConstante(int posicionDelIdentificador)
{
    tablaDeSimbolos[posicionDelIdentificador].esVariable = 1;
}
void asignarValorAIdentificador(char identificador[255], exp expresion)
{
    int posicion = posicionDelIdentificador(identificador);
    
    if(tablaDeSimbolos[posicion].valor.tipo == expresion.tipo)
    {
        tablaDeSimbolos[posicion].valor = expresion;
        return;
    }

    printf("Error: El tipo de la expresion coincide con el tipo del identificador\n | Tipo del identificador: %i\n | Tipo de la expresion: %i\n", tablaDeSimbolos[posicion].valor.tipo, expresion.tipo);
}

// Entrada / Salida

void escribir(nodoExp *expresiones){}
void leer(nodoID *identificadores){}
void imprimirExpresion(exp expresion)
{
    if(expresion.tipo == INT)
    {
        printf("%f", expresion.valor);
    }
    if(expresion.tipo == STRING)
    {
        printf("%s", expresion.cadena);
    }
}

// Expresiones

exp asignarValorAPrimaria(float valor)
{
    return crearExpresionNumerica(valor);
}

exp reducirExpresion(exp primaria, char operador, exp expresionAritmetica)
{
    if ( operador == '+') {
        return crearExpresionNumerica(primaria.valor + expresionAritmetica.valor);
    } else {
        return crearExpresionNumerica(primaria.valor - expresionAritmetica.valor);
    }
}

exp asignarCadenaAExpresion(char *cadena)
{
    exp nuevaExpresion;
    nuevaExpresion.tipo = STRING; 
    nuevaExpresion.cadena = cadena;
    return nuevaExpresion;
}

// Otras

void inicializarTablaDeSimbolos()
{
    for(int i = 0; i < TAMANIO_TS; i++)
    {
        tablaDeSimbolos[i].valor.tipo = ENTRADAVACIA;
    }
}

int posicionVacia(char identificador[255])
{
    int i = 0;
    for(i; !strcmp(tablaDeSimbolos[i].identificador, identificador) && i < TAMANIO_TS; i++)
    {
        if(tablaDeSimbolos[i].valor.tipo == ENTRADAVACIA)
        return i;
    }
    
    if(strcmp(tablaDeSimbolos[i].identificador, identificador))
    {
        printf("Error: Ya existe el identificador \"%s\"\n", identificador);
        return -1;
    }
    
    if(!(i < TAMANIO_TS))
    {
        printf("Error: La tabla de simbolos no puede almacenar mas identificadores\n");
        return -2;
    }
}

int posicionDelIdentificador(char identificador[255])
{
    for(int i = 0; i < TAMANIO_TS; i++)
    {
        if(strcmp(tablaDeSimbolos[i].identificador, identificador))
        return i;
    }

    printf("Error: El identificador \"%s\" no esta declarado\n", identificador);
    return -1;
}

exp crearExpresionNumerica(float valor)
{
    exp nuevaExpresion;
    nuevaExpresion.tipo = INT;
    nuevaExpresion.valor = valor;
    return nuevaExpresion;
}

exp valorDeIdentificador(char identificador[255])
{
    int posicion = posicionDelIdentificador(identificador);

    return tablaDeSimbolos[posicion].valor;
}