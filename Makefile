TARGET = Compilador

#make Compilador
$(TARGET) : AnalizadorSintactico AnalizadorLexico
	gcc -o $(TARGET)  AnalizadorSintactico.tab.c lex.yy.c

AnalizadorSintactico: AnalizadorSintactico.y
	bison -dv AnalizadorSintactico.y

AnalizadorLexico: AnalizadorLexico.l
	flex -l AnalizadorLexico.l


#make clear
clear:
	rm -f $(TARGET)  lex.yy.c AnalizadorSintactico.output AnalizadorSintactico.output AnalizadorSintactico.tab.c AnalizadorSintactico.tab.h