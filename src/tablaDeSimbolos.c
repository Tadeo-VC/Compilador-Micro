#include "../hdrs/tablaDeSimbolos.h"
#include <stdio.h>
#include <string.h>

// Declaraciones y Asignaciones

void declararVariableInt(char identificador[255]){}
void declararConstanteInt(char identificador[255]){}
void declararVariableString(char identificador[255]){}
void declararConstanteString(char identificador[255]){}
void asignarValorAIdentificador(char identificador[255], exp expresion){}

// Entrada / Salida

void escribir(nodoExp *expresiones){}
void leer(nodoID *identificadores){}

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
    nuevaExpresion.tipo = CADENA; 
    nuevaExpresion.cadena = cadena;
    return nuevaExpresion;
}

// Otras

exp crearExpresionNumerica(float valor)
{
    exp nuevaExpresion;
    nuevaExpresion.tipo = NUMERICO;
    nuevaExpresion.valor = valor;
    return nuevaExpresion;
}

exp valorDeIdentificador(char identificador[255]){}