TARGET = Compilador

#make Compilador
$(TARGET) : AnalizadorSintactico AnalizadorLexico
	gcc -o $(TARGET)  AnalizadorSintactico.tab.c lex.yy.c src/tablaDeSimbolos.c

AnalizadorSintactico: 
	bison -dv src/AnalizadorSintactico.y

AnalizadorLexico: 
	flex -l src/AnalizadorLexico.l


#make clear
clear:
	rm -f $(TARGET)  lex.yy.c AnalizadorSintactico.output AnalizadorSintactico.output AnalizadorSintactico.tab.c AnalizadorSintactico.tab.h