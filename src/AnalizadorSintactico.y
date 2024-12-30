%{
    #include "hdrs/tablaDeSimbolos.h"
    extern int yylex();
    int yyerror(char *);
    extern FILE* yyin;  
%}

%token INICIO FIN LEER ESCRIBIR INT STRING CONST IDENTIFICADOR LITERALCADENA CONSTANTENUMERICA '+' '-' ';' ',' '(' ')' ASIGNACION

%union{
    char  id[255];
    char* string;
    int   numerico;
    int   posicion;
    char  operador;
    exp   tExp;
}

%type <id>       IDENTIFICADOR 
%type <string>   LITERALCADENA
%type <numerico> CONSTANTENUMERICA
%type <posicion> declaracionInt declaracionString // las declaraciones pasan la posicion del identificador para volverlo constante
%type <operador> '+' '-' operadorAditivo
%type <tExp>     expresion expresionAritmetica primaria

%% // Gramatica

// Estructura
objetivo:
    programa    
;
programa: INICIO listaDeSentencias FIN
;
listaDeSentencias: sentencia ';' listaDeSentencias 
                 | sentencia ';'
;
sentencia: declaracion 
         | asignacion 
         | entradaSalida 
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
asignacion: IDENTIFICADOR ASIGNACION expresion    {asignarValorAIdentificador($1, $3);} 
;

// Entrada y Salida 
entradaSalida: ESCRIBIR '(' listaDeExpresiones ')'  
             | LEER '(' listaDeIdentificadores ')'  
;

// Listas y Expresiones

listaDeIdentificadores: IDENTIFICADOR ',' listaDeIdentificadores    {printf("%s", $1);;}    
                      | IDENTIFICADOR                               {printf("%s", $1);}
;

listaDeExpresiones: expresion ',' listaDeExpresiones    {imprimirExpresion($1);}    
                  | expresion                           {imprimirExpresion($1);}
;
expresion: expresionAritmetica  {$$ = $1;}                            // de acuerdo al tipo que le llegue se le asigna el valor y el tipo a la expresion 
         | LITERALCADENA        {$$ = asignarCadenaAExpresion($1);}   //
;
expresionAritmetica: primaria operadorAditivo expresionAritmetica   {$$ = reducirExpresion($1, $2, $3);} // reducir expresion 
                   | primaria                                       {$$ = $1;}
;
primaria: IDENTIFICADOR                 {exp expresion = valorDeIdentificador($1); $$ = asignarValorAPrimaria(expresion.valor);}
        | CONSTANTENUMERICA             {$$ = asignarValorAPrimaria($1);}
        | '(' expresionAritmetica ')'   {$$ = $2;}
;
operadorAditivo: '+'    {$$ = $1;}    
               | '-'    {$$ = $1;}
;

%%

int yyerror(char *cadena){
    printf("Error Sintactico: %s\n", cadena);
    return 0;
} 

int main(int argc, char *argv[]) 
{
    if(argc == 2){ // Entrada por archivo
        yyin = fopen(argv[1],"r");
    } else {       // Entrada por teclado
        yyin = stdin;
    }

    inicializarTablaDeSimbolos();

    switch(yyparse())
    {
        case 0: printf("El análisis ha finalizado exitosamente.\n");
        case 1: fprintf(stderr, "Error de análisis sintáctico.\n");
        case 2: fprintf(stderr, "Error de memoria en yyparse.\n");
    }
}