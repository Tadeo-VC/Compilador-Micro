%{
    #include "hdrs/tablaDeSimbolos.h"
    #include "AnalizadorSintactico.tab.h"
    
    void ErrorLexico(char *);
%}

%option noyywrap

letra               [a-zA-Z]
digito              [0-9]

identificador       ({letra}|_)({letra}|{digito})*
literalCadena       \"(\\.|[^\"\\])*\"
constanteNumerica   ({digito})

espaciosEnBlanco    [\t\n]+

%% 

"inicio"                return INICIO;                                                                    
"fin"                   return FIN;                                      
"leer"                  return LEER;                                       
"escribir"              return ESCRIBIR;                                  
"int"                   return INT;                               
"string"                return STRING;
"const"                 return CONST;

{identificador}         {strcpy(yylval.id, yytext);     return IDENTIFICADOR;}                                 
{literalCadena}         {yylval.string = yytext;        return LITERALCADENA;}                                
{constanteNumerica}     {yylval.numerico = atoi(yytext);  return CONSTANTENUMERICA;}        

"+"                     return '+';                                 
"-"                     return '-';                                 
";"                     return ';';                                 
","                     return ',';
"("                     return '(';
")"                     return ')';                                 
"=:"                    return ASIGNACION;                    

{espaciosEnBlanco}      ;                   
.                       ErrorLexico(yytext);

%%

void ErrorLexico(char *cadena)
{
    printf("Error Lexico: %s\n", cadena);
}