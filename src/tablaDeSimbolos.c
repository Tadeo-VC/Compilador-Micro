#include "../hdrs/tablaDeSimbolos.h"

TS tablaDeSimbolos[TAMANIO_TS];
exp listaDeExpresiones[TAMANIO_LEXP];

// Declaraciones y Asignaciones

int declararVariable(enum tipoDeDato tipo, char identificador[255])
{
    int nuevaPosicion = posicionVacia(identificador);
    strcpy(tablaDeSimbolos[nuevaPosicion].identificador, identificador);
    tablaDeSimbolos[nuevaPosicion].esVariable = 0;

    if(tipo == NUMERICO)
    {
        tablaDeSimbolos[nuevaPosicion].valor.tipo = NUMERICO;
    }
    if(tipo == CADENA)
    {
        tablaDeSimbolos[nuevaPosicion].valor.tipo = CADENA;
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

exp ingresarValorDeIdentificador(char identificador[255])
{
    int posicion = posicionDelIdentificador(identificador);

    if(tablaDeSimbolos[posicion].valor.tipo == NUMERICO)
    {
        int valorIngresado;
        scanf("%i", &valorIngresado);
        return crearExpresionNumerica(valorIngresado);
    } 
    if(tablaDeSimbolos[posicion].valor.tipo == CADENA)
    {
        char *cadenaIngresada;
        scanf("%s", cadenaIngresada);
        return asignarCadenaAPrimaria(cadenaIngresada);
    }

    printf("Error: El identificador no tiene un tipo asignado");
    return tablaDeSimbolos[posicion].valor;
}

// Entrada / Salida

void inicializarListaDeExpresiones()
{
    for(int i = 0; i < TAMANIO_LEXP; i++)
    listaDeExpresiones[i].tipo = ENTRADAVACIA;
    
    return;
}

void agregarExpresion(exp expresion)
{
    int i = 0;
    while(listaDeExpresiones[i].tipo != ENTRADAVACIA && i < TAMANIO_LEXP)
    i++;

    if(i < TAMANIO_LEXP){
        listaDeExpresiones[i] = expresion;
    } else {
        printf("Error: esto pasa por haberlo hecho con un vector y no con una cola (mucho laburo). No Agregue nada. \n| Cantidad maxima de expresiones: %i", TAMANIO_LEXP);   
    }
}

void escribir()
{
    int i = 0;
    for(i; i < TAMANIO_LEXP && listaDeExpresiones[i].tipo != ENTRADAVACIA; i++)
    imprimirExpresion(listaDeExpresiones[i]);  

    return;
}

// Expresiones

exp reducirExpresion(exp primaria, char operador, exp expresionAritmetica)
{
    if ( operador == '+') {
        return crearExpresionNumerica(primaria.valor + expresionAritmetica.valor);
    } else {
        return crearExpresionNumerica(primaria.valor - expresionAritmetica.valor);
    }
}

exp asignarEnteroAPrimaria(int valor)
{
    return crearExpresionNumerica(valor);
}

exp asignarCadenaAPrimaria(char *cadena)
{
    exp nuevaExpresion;
    nuevaExpresion.tipo = CADENA; 
    nuevaExpresion.cadena = strdup(cadena);
    return nuevaExpresion;
}

// Otras

void inicializarTablaDeSimbolos()
{
    for(int i = 0; i < TAMANIO_TS; i++)
    tablaDeSimbolos[i].valor.tipo = ENTRADAVACIA;
    
    return;
}

int posicionVacia(char identificador[255])
{
    int i = 0;
    for(i; tablaDeSimbolos[i].valor.tipo != ENTRADAVACIA && i < TAMANIO_TS; i++)
    {
        if(!strcmp(tablaDeSimbolos[i].identificador, identificador))
        {
            printf("Error: Ya existe el identificador \"%s\"\n", identificador);
            return -1;
        }
    }

    if(i < TAMANIO_TS){
        return i;
    } else {
        printf("Error: No hay mas espacio en la tabla de simbolos\n");
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

void imprimirExpresion(exp expresion)
{
    if(expresion.tipo == NUMERICO)
    printf("%d\n", expresion.valor);
    
    if(expresion.tipo == CADENA)
    printf("%s\n", expresion.cadena);
    
    return;
}

exp crearExpresionNumerica(int valor)
{
    exp nuevaExpresion;
    nuevaExpresion.tipo = NUMERICO;
    nuevaExpresion.valor = valor;
    return nuevaExpresion;
}

exp valorDeIdentificador(char identificador[255])
{
    int posicion = posicionDelIdentificador(identificador);

    return tablaDeSimbolos[posicion].valor;
}