%{
    #include "../hdrs/tablaDeSimbolos.h"
%}

%token INICIO FIN LEER ESCRIBIR INT STRING CONST IDENTIFICADOR LITERALCADENA CONSTANTENUMERICA '+' '-' ';' ',' '(' ')' '=:'

%union{
    char id[255];
    char* string;
    int numerico;
    char operador;
    exp tExp;

%type <id>     IDENTIFICADOR declaracionInt declaracionString // declaracionInt y declaracionString almacenan el IDENTIFICADOR
%type <string> LITERALCADENA
%type <numerico> CONSTANTENUMERICA expresionAritmetica
%type <operador> '+' '-'
%type <tExp> expresion 

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
           | CONST declaracionInt       {declararConstante($2);} // cambiar tipo constante
           | declaracionString          
           | CONST declaracionString    {declararConstante($2);} // cambiar tipo constante
;
declaracionInt: INT IDENTIFICADOR       {strcpy($$, $2); declararVariable("int", $2);} // declarar variable entera y pasar identificador a declaracion para cambiar a constante
;
declaracionString: STRING IDENTIFICADOR {strcpy($$, $2); declararVariable("string", $2);} // declarar variable string y pasar identificador a declaracion para cambiar a constante
;

// Asignaciones
asignacion: IDENTIFICADOR '=:' expresion    {asignarValorAIdentificador($1, $3);} // asignar valor a variable 
;

// Entrada y Salida 
entradaSalida: ESCRIBIR '(' listaDeExpresiones ')'  {escribir($3);} // printear expresiones reducidas, variables Y texto en pantalla
             | LEER '(' listaDeIdentificadores ')'  {leer($3);}     // asignar valor de la expresion reducida ingresada por teclado a cada variable
;

// 

listaDeIdentificadores: IDENTIFICADOR ',' listaDeIdentificadores    {$$ = queue($$, $1);}    
                      | IDENTIFICADOR                               {$$ = queue($$, $1);}
;

listaDeExpresiones: expresion ',' listaDeExpresiones    {$$ = queue($$, $1);}    
                  | expresion                           {$$ = queue($$, $1);}
;
expresion: expresionAritmetica  {$$ = asignarNumericoAExpresion($1);} // de acuerdo al tipo que le llegue se le asigna el valor y el tipo a la expresion 
         | LITERALCADENA        {$$ = asignarCadenaAExpresion($1);}   //
;
expresionAritmetica: primaria operadorAditivo expresionAritmetica   {$$ = reducirExpresion($1, $2, $3);} // reducir expresion 
                   | primaria                                       {$$ = reducirPrimaria($1);}
;
primaria: IDENTIFICADOR                 {asignarValorAPrimaria(valorDeIdentificador($1));}
        | CONSTANTENUMERICA             {asignarValorAPrimaria($1);}
        | '(' expresionAritmetica ')'   {asignarValorAPrimaria(asignarNumericoAExpresion($1));}
;
operadorAditivo: '+'    {$$ = $1;}    
               | '-'    {$$ = $1;}
;