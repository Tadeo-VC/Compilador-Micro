%{
    #import "tablaDeSimbolos.h"
%}

%token INICIO FIN LEER ESCRIBIR INT STRING CONST IDENTIFICADOR LITERALCADENA CONSTANTENUMERICA '+' '-' ';' ',' '(' ')' '=:'

%union{
    char id[255];
    char* string;
    float number;
}

%type <id>     IDENTIFICADOR
%type <string> LITERALCADENA
%type <number> CONSTANTENUMERICA

%% // Gramatica

// Estructura
objetivo:
    programa
;
programa: INICIO listaDeSentencias FIN
;
listaDeSentencias: sentencia listaDeSentencias 
                 | sentencia 
;
sentencia: declaracion ';'
         | asignacion ';'
         | entradaSalida ';'
; 

// Declaraciones
declaracion:
           | declaracionInt             
           | CONST declaracionInt       {} // cambiar tipo constante
           | declaracionString          
           | CONST declaracionString    {} // cambiar tipo constante
;
declaracionInt: INT IDENTIFICADOR       {} // declarar variable entera
;
declaracionString: STRING IDENTIFICADOR {} // declarar variable string
;

// Asignaciones
asignacion: IDENTIFICADOR '=:' expresion    {} // asignar valor a variable 
;

// Entrada y Salida 
entradaSalida: ESCRIBIR '(' listaDeExpresiones ')'  {} // printear expresiones reducidas, variables Y texto en pantalla
             | LEER '(' listaDeIdentificadores ')'  {} // asignar valor de la expresion reducida ingresada por teclado a cada variable
;

// 

listaDeIdentificadores: IDENTIFICADOR ',' listaDeIdentificadores
                      | IDENTIFICADOR
;

listaDeExpresiones: expresion ',' listaDeExpresiones    
                  | expresion
;
expresion: expresionAritmetica 
         | LITERALCADENA
;
expresionAritmetica: primaria operadorAditivo expresion 
         | primaria 
;
primaria: IDENTIFICADOR
        | CONSTANTENUMERICA
        | '(' expresion ')'
;
operadorAditivo: '+'
               | '-'
;