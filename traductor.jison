/**
 * Proyecto 2 - Organización de Lenguajes y Compiladores 1
 * Traductor de C# a Python
 * Gramática de C#
 */

/* Definición Léxica */
%lex

%options case-insensitive

%%

"("                 return 'CL_PARENTESIS_1';
")"                 return 'CL_PARENTESIS_2';
"{"                 return 'CL_LLAVES_1';
"}"                 return 'CL_LLAVES_2';
","                 return 'CL_COMA';
";"					return 'CL_PUNTO_COMA';
"."					return 'CL_PUNTO';
"="					return 'CL_IGUAL';
":"					return 'CL_DOS_PUNTOS';
"+"                 return 'OP_SUMA';
"-"                 return 'OP_RESTA';
"*"                 return 'OP_POR';
"/"                 return 'OP_DIV';
"&&"                return 'OP_AND';
"||"                return 'OP_OR';
"!"                	return 'OP_NOT';
">"                	return 'OP_MAYOR';
"<"                	return 'OP_MENOR';
">="                return 'OP_MAYOR_IGUAL';
"<="                return 'OP_MENOR_IGUAL';
"!="                return 'OP_DISTINTO';

"Void"              return 'PR_VOID';
"Main"              return 'PR_MAIN';
"Console"           return 'PR_CONSOLE';
"Write"             return 'PR_WRITE';
"If"             	return 'PR_IF';
"Else"              return 'PR_ELSE';
"Switch"            return 'PR_SWITCH';
"Case"              return 'PR_CASE';
"Default"           return 'PR_DEFAULT';
"For"              	return 'PR_FOR';
"While"             return 'PR_WHILE';
"Do"              	return 'PR_DO';
"Return"            return 'PR_RETURN';
"Break"             return 'PR_BREAK';
"Continue"          return 'PR_CONTINUE';
"True"				return 'TRUE';
"False"				return 'FALSE';

/* Espacios en blanco */
[ \r\t]+            {}
\n                  {}

[0-9]+("."[0-9]+)?    		return 'FLOTANTE';
[0-9]+                		return 'ENTERO';
[a-zA-Z]+[a-zA-Z0-9_]* 		return 'ID';
'.' 						return 'CARACTER';
'.*' 						return 'HTML';
\"[^\"]*\" 					return 'CADENA';

\/\*[^\*]*[^\/]*\*\/		{ console.error('Comentario de bloque');}
^(\/\/.*\n)					{ console.error('Comentario linea'); }


<<EOF>>                 return 'EOF';

.                       { console.error('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }
/lex

/* Asociación de operadores y precedencia */

%left 'OP_SUMA' 'OP_RESTA'
%left 'OP_POR' 'OP_DIV'
%left 'OP_NOT' 'OP_AND' 'OP_OR'
%left UMENOS

%start ini

%% /* Definición de la gramática */

ini
	: INICIO EOF
;

INICIO
	: L_SENTENICAS
	| AREA_MAIN
;

instrucciones
	: instruccion instrucciones
	| instruccion
	| error { console.error('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

instruccion
	: REVALUAR CORIZQ expresion CORDER PTCOMA {
		console.log('El valor de la expresión es: ' + $3);
	}
;

expresion
	: MENOS expresion %prec UMENOS  { $$ = $2 *-1; }
	| expresion MAS expresion       { $$ = $1 + $3; }
	| expresion MENOS expresion     { $$ = $1 - $3; }
	| expresion POR expresion       { $$ = $1 * $3; }
	| expresion DIVIDIDO expresion  { $$ = $1 / $3; }
	| ENTERO                        { $$ = Number($1); }
	| DECIMAL                       { $$ = Number($1); }
	| PARIZQ expresion PARDER       { $$ = $2; }
;