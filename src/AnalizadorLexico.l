%{ // Definiciones
    #include <stdio.h>
    #include <string.h>
    #include "AnalizadorSintactico.tab.h"

    void ErrorLexico(char *);
%}

// Patrones

identificador       {noDigito}{noDigito|Digito}*
constanteNumerica   {Digito}*
literalCadena       "(\\.|[^"\\])*"

noDigito            _|[a-zA-Z]
Digito              [0-9]

espaciosEnBlanco    [ \t\n]

%% // Reglas

"inicio"            return INICIO;                                                                    
"fin"               return FIN;                                      
"leer"              return LEER;                                       
"escribir"          return ESCRIBIR;                                  
"int"               return INT;                               
"string"            return STRING;
"cont"              return CONST;                   

{identificador}       {strcpy(yylval.id, yytext); return IDENTIFICADOR;}                                 
{literalCadena}       {yylval.string = yytext; return LITERALCADENA;}                                
{constanteNumerica}   {yylval.number = atoi(yytext); return CONSTANTENUMERICA;}                   

"+"                 return '+';                                 
"-"                 return '-';                                 
";"                 return ';';                                 
","                 return ',';
"("                 return '(';
")"                 return ')';                                 
"=:"                return '=:';                    

espaciosEnBlanco    ; // No hace nada                    
.                   ErrorLexico(yytext);

%%

// Codigo De Usuario

void ErrorLexico(char *cadena)
{
    printf("Error Lexico: %s\n", cadena);
}

int main() 
{
    yylex();
    return 0;
}