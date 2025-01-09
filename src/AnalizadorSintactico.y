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
%type <posicion> declaracionInt declaracionString 
%type <operador> '+' '-' operadorAditivo
%type <tExp>     expresion primaria

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
           | CONST declaracionInt ASIGNACION expresion      {declararConstante($2);} 
           | declaracionString        
           | CONST declaracionString ASIGNACION expresion   {declararConstante($2);}
;
declaracionInt: INT IDENTIFICADOR       {$$ = declararVariable(0, $2);}  // 0 = INT,    retorna la posicion del identificador
;
declaracionString: STRING IDENTIFICADOR {$$ = declararVariable(1, $2);}  // 0 = STRING, retorna la posicion del identificador
;

// Asignaciones
asignacion: IDENTIFICADOR ASIGNACION expresion    {asignarValorAIdentificador($1, $3);} 
;

// Entrada y Salida 
entradaSalida: ESCRIBIR '(' listaDeExpresiones ')'  
             | LEER '(' listaDeIdentificadores ')'  
;

// Listas y Expresiones

listaDeIdentificadores: IDENTIFICADOR ',' listaDeIdentificadores    {asignarValorAIdentificador($1, ingresarValorDeIdentificador($1));}    
                      | IDENTIFICADOR                               {asignarValorAIdentificador($1, ingresarValorDeIdentificador($1));}
;

listaDeExpresiones: expresion ',' listaDeExpresiones        {imprimirExpresion($1);} // ACA YA LLEGAN MAL            
                  | expresion                               {imprimirExpresion($1);} // ACA YA LLEGAN MAL       
;
expresion: primaria operadorAditivo expresion   {$$ = reducirExpresion($1, $2, $3);} //ACA TAMBIEN LLEGAN MAL YA ESTA PRIMARIA HDP TE TENGO
         | primaria                             {$$ = $1;}                           //ACA TAMBIEN LLEGAN MAL YA ESTA PRIMARIA HDP TE TENGO
;
primaria: IDENTIFICADOR         {$$ = valorDeIdentificador($1);}      // LOS VALORES INGRESAN BIEN A PRIMARIA, PERO SE ALMACENAN MAL YA ESTA PRIMARIA HDP
        | '(' expresion ')'     {$$ = $2;}                            // CUANDO SE DEFINEN LOS VALORES ENTRAN BIEN, PERO DESPUES ARRANCA EL DELIRIO
        | CONSTANTENUMERICA     {$$ = asignarEnteroAPrimaria($1);}    // EL VALOR QUE SE COPIA EN BUCLE ES EL DE LA ULTIMA VARIBLE DEFINIDA O 0 SI HAY 0-1 VARIABLE DEFINIDA
        | LITERALCADENA         {$$ = asignarCadenaAPrimaria($1);}   
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
    if(argc == 2){ 
        yyin = fopen(argv[1],"r");
    } else {      
        yyin = stdin;
    }

    inicializarTablaDeSimbolos();

    switch(yyparse())
    {
        case 0: printf("El análisis ha finalizado exitosamente.\n"); break;
        case 1: fprintf(stderr, "Error de análisis sintáctico.\n"); break;
        case 2: fprintf(stderr, "Error de memoria en yyparse.\n"); break;
    }
}