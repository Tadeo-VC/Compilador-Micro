%{
    #include "../hdrs/tablaDeSimbolos.h"
%}

%token INICIO FIN LEER ESCRIBIR INT STRING CONST IDENTIFICADOR LITERALCADENA CONSTANTENUMERICA '+' '-' ';' ',' '(' ')' '=:'

%union{
    char  id[255];
    char* string;
    float numerico;
    int   posicion;
    char  operador;
    exp   tExp;

%type <id>       IDENTIFICADOR 
%type <string>   LITERALCADENA
%type <numerico> CONSTANTENUMERICA expresionAritmetica
%type <posicion> declaracionInt declaracionString // las declaraciones pasan la posicion del identificador para volverlo constante
%type <operador> '+' '-'
%type <tExp>     expresion expresionAritmetica primaria

%% // Gramatica

// Estructura
objetivo:
    programa    {inicializarTablaDeSimbolos();}
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

// Declaraciones y Asignacion
declaracion:    
           | declaracionInt           
           | CONST declaracionInt       {declararConstante($2);} 
           | declaracionString        
           | CONST declaracionString    {declararConstante($2);}
;
declaracionInt: INT IDENTIFICADOR       {$$ = declararVariable(0, $2);}  // 0 = INT, retorna la posicion del identificador
;
declaracionString: STRING IDENTIFICADOR {$$ = declararVariable(1, $2);}  // 0 = STRING, retorna la posicion del identificador

// Asignaciones
asignacion: IDENTIFICADOR '=:' expresion    {asignarValorAIdentificador($1, $3);} 
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
expresion: expresionAritmetica  {$$ = $1;}                            // de acuerdo al tipo que le llegue se le asigna el valor y el tipo a la expresion 
         | LITERALCADENA        {$$ = asignarCadenaAExpresion($1);}   //
;
expresionAritmetica: primaria operadorAditivo expresionAritmetica   {$$ = reducirExpresion($1, $2, $3);} // reducir expresion 
                   | primaria                                       {$$ = $1;}
;
primaria: IDENTIFICADOR                 {$$ = asignarValorAPrimaria(valorDeIdentificador($1));}
        | CONSTANTENUMERICA             {$$ = asignarValorAPrimaria($1);}
        | '(' expresionAritmetica ')'   {$$ = $2;}
;
operadorAditivo: '+'    {$$ = $1;}    
               | '-'    {$$ = $1;}
;