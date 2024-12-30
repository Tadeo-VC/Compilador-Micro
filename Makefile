TARGET = Compilador

#make Compilador
$(TARGET) : AnalizadorSintactico AnalizadorLexico
	gcc -o $(TARGET)  src/AnalizadorSintactico.tab.c src/lex.yy.c

AnalizadorSintactico: 
	bison -dv src/AnalizadorSintactico.y

AnalizadorLexico: 
	flex -l src/AnalizadorLexico.l


#make clear
clear:
	rm -f $(TARGET)  lex.yy.c src/AnalizadorSintactico.output src/AnalizadorSintactico.output src/AnalizadorSintactico.tab.c src/AnalizadorSintactico.tab.h