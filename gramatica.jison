/**
 * Proyecto 2 - Organización de Lenguajes y Compiladores 1
 * Traductor de C# a Python
 * Gramática de C#
 */

/* Definición Léxica */
%lex

%options case-insensitive

%%
\s+	//Espacio en blanco
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] //Comentario bloque
"//".* //Comentario línea

"("                 { return '('; }
")"                 { return ')'; }
"{"                 { return '{'; }
"}"                 { return '}'; }
","                 { return ','; }
";"					{ return ';'; }
"."					{ return '.'; }
"="					{ return '='; }
":"					{ return ':'; }
"+"                 { return '+'; }
"-"                 { return '-'; }
"*"                 { return '*'; }
"/"                 { return '/'; }
"&&"                { return '&&'; }
"||"                { return '||'; }
"!"                	{ return '!'; }
">"                	{ return '>'; }
"<"                	{ return '<'; }
//">="                { return '>='; }
//"<="                { return '<='; }
//"!="                { return '!='; }
"++"				{ return '++'; }
"--"				{ return '--'; }
//"=="				{ return '=='; }

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
"Int"				return 'PR_INT';
"Double"			return 'PR_DOUBLE';
"Char"				return 'PR_CHAR';
"Bool"				return 'PR_BOOL';
"String"			return 'PR_STRING';

/* Espacios en blanco */
//[ \r\t]+            {}
//\n                  {}

[0-9]+("."[0-9]+)?    		return 'FLOTANTE';
[0-9]+               		return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]* 	return 'ID';
\'[^\']\'  					{ yytext = yytext.substr(1,yyleng-2); return 'CARACTER'; }
\'[^\']*\' 					{ yytext = yytext.substr(1,yyleng-2); return 'HTML'; }

\"[^\"]*\"							{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }

<<EOF>>                 return 'EOF';

.                       { console.log('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column); }

/lex

%{
	//Codigo JavaScript
%}

/* Asociación de operadores y precedencia */
%left '+' '-'
%left '*' '/'
//%left '<' '>' '<=' '>=' '==' '!='
%left '<' '>' '!' '='
%left '!' '&&' '||'
//%left '--' '++'
%left UMENOS

%start ini

%% /* Definición de la gramática */

ini
	: sentencias EOF { return $1; }
;

sentencias
	: sentencias sentencia 	{ $1.push($2); $$ = $1; }
	| sentencia 			{ $$ = [$1]; }
;

sentencia
	: tipo_dato lista_id asignacion ';' 	{ console.log($1,$2,$3,$4); }
	| tipo_dato lista_id ';' 				{ console.log($1,$2,$3,); }
	| ID '=' expresion ';'					{ console.log($1,$2,$3,$4); }
	| PR_VOID ID '(' parametros ')' '{' sentencias_m '}' 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| PR_VOID ID '(' parametros ')' '{' '}'					{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_VOID ID '(' ')' '{' sentencias_m '}' 				{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_VOID ID '(' ')' '{' '}'  							{ console.log($1,$2,$3,$4,$5,$6); }
	| tipo_dato ID '(' parametros ')' '{' sentencias_m '}' 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| tipo_dato ID '(' parametros ')' '{' '}' 				{ console.log($1,$2,$3,$4,$5,$6); }
	| tipo_dato ID '(' ')' '{' sentencias_m '}' 			{ console.log($1,$2,$3,$4,$5,$6,$7); }
//	| tipo_dato ID '(' ')' '{' '}' 							{ console.log($1,$2,$3,$4); }
	| PR_IF '(' expresion ')' '{' sentencias_m '}' else_if 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| PR_IF '(' expresion ')' '{' sentencias_m '}' 			{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_IF '(' expresion ')' '{' '}' else_if 				{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_IF '(' expresion ')' '{' '}' 						{ console.log($1,$2,$3,$4,$5,$6); }
	| PR_SWITCH '(' expresion ')' '{' lista_case '}' 		{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_FOR '(' tipo_dato ID '=' expresion ';' expresion ';' paso ')' '{' sentencias_m '}' 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13); }
	| PR_FOR '(' tipo_dato ID '=' expresion ';' expresion ';' paso ')' '{' '}'					{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12); }
	| PR_FOR '(' ID '=' expresion ';' expresion ';' paso ')' '{' sentencias_m '}' 				{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13); }
	| PR_FOR '(' ID '=' expresion ';' expresion ';' paso ')' '{' '}' 							{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12); }
	| PR_WHILE '(' expresion ')' '{' sentencias_m '}' 											{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_WHILE '(' expresion ')' '{' '}' 														{ console.log($1,$2,$3,$4,$5,$6); }
	| PR_DO '{' sentencias_m '}' PR_WHILE '(' expresion ')' ';' 								{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9); }
	| PR_DO '{' '}' PR_WHILE '(' expresion ')' ';' 			{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| PR_CONSOLE '.' PR_WRITE '(' expresion ')' ';' 		{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_RETURN expresion ';'								{ console.log($1,$2,$3); }
	| PR_RETURN ';' 										{ console.log($1,$2); }
	| PR_BREAK ';' 											{ console.log($1,$2); }
	| PR_CONTINUE ';' 										{ console.log($1,$2); }
	| PR_VOID PR_MAIN '(' ')' '{' sentencias_m '}' 			{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_VOID PR_MAIN '(' ')' '{' '}' 						{ console.log($1,$2,$3,$4,$5,$6); }
	| error { console.log('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

tipo_dato
	: PR_INT 		{ $$ = $1;}
	| PR_DOUBLE		{ $$ = $1;}
	| PR_CHAR		{ $$ = $1;}
	| PR_BOOL		{ $$ = $1;}
	| PR_STRING		{ $$ = $1;}
;

lista_id
	: lista_id ',' ID  	{ $1.push($3); $$ = $1; }
	| ID 				{ $$ = [$1]; }
;

asignacion
	: '=' expresion { $$ = $1 + $2; }
;

parametros
	: parametros ',' parametro 	{ $1.push($3); $$ = $1; }
	| parametro 				{ $$ = [$1]; }
;

parametro
	: tipo_dato ID { $$ = $1 + $2; }
;

else_if
	: else_if elif 	{ $1.push($2); $$ = $1; }
	| elif 			{ $$ = [$1]; }
;

elif
	: PR_ELSE PR_IF '(' expresion ')' '{' sentencias_m '}' 	{ $$ = $1 + $2 + $3 + $4 + $5 + $6 + $7 + $8; }
	| PR_ELSE PR_IF '(' expresion ')' '{' '}'				{ $$ = $1 + $2 + $3 + $4 + $5 + $6 + $7; }
	| PR_ELSE '{' sentencias_m '}' 							{ $$ = $1 + $2 + $3 + $4; }
	| PR_ELSE '{' '}' 										{ $$ = $1 + $2 + $3; }
;

lista_case
	: lista_case case 	{ $1.push($2); $$ = $1; }
	| case 				{ $$ = [$1]; }
;

case
	: PR_CASE expresion ':' sentencias_m 	{ $$ = $1 + $2 + $3 + $4; }
	| PR_DEFAULT ':' sentencias_m 			{ $$ = $1 + $2 + $3; }
;

paso
	: ID '+' '+' 	{ $$ = $1 + $2 + $3; }
	| ID '-' '-' 	{ $$ = $1 + $2 + $3; }
;

sentencias_m
	: sentencias_m sentencia_m 	{ $1.push($2); $$ = $1; }
	| sentencia_m 				{ $$ = [$1]; }
;

sentencia_m
	: tipo_dato lista_id asignacion ';' 	{ console.log($1,$2,$3,$4); }
	| tipo_dato lista_id ';' 				{ console.log($1,$2,$3,); }
	| ID '=' expresion ';'					{ console.log($1,$2,$3,$4); }
	| PR_VOID ID '(' parametros ')' '{' sentencias_m '}' 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| PR_VOID ID '(' parametros ')' '{' '}'					{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_VOID ID '(' ')' '{' sentencias_m '}' 				{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_VOID ID '(' ')' '{' '}'  							{ console.log($1,$2,$3,$4,$5,$6); }
	| tipo_dato ID '(' parametros ')' '{' sentencias_m '}' 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| tipo_dato ID '(' parametros ')' '{' '}' 				{ console.log($1,$2,$3,$4,$5,$6); }
	| tipo_dato ID '(' ')' '{' sentencias_m '}' 			{ console.log($1,$2,$3,$4,$5,$6,$7); }
//	| tipo_dato ID '(' ')' '{' '}' 							{ console.log($1,$2,$3,$4); }
	| PR_IF '(' expresion ')' '{' sentencias_m '}' else_if 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| PR_IF '(' expresion ')' '{' sentencias_m '}' 			{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_IF '(' expresion ')' '{' '}' else_if 				{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_IF '(' expresion ')' '{' '}' 						{ console.log($1,$2,$3,$4,$5,$6); }
	| PR_SWITCH '(' expresion ')' '{' lista_case '}' 		{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_FOR '(' tipo_dato ID '=' expresion ';' expresion ';' paso ')' '{' sentencias_m '}' 	{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13); }
	| PR_FOR '(' tipo_dato ID '=' expresion ';' expresion ';' paso ')' '{' '}'					{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12); }
	| PR_FOR '(' ID '=' expresion ';' expresion ';' paso ')' '{' sentencias_m '}' 				{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13); }
	| PR_FOR '(' ID '=' expresion ';' expresion ';' paso ')' '{' '}' 							{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12); }
	| PR_WHILE '(' expresion ')' '{' sentencias_m '}' 											{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_WHILE '(' expresion ')' '{' '}' 														{ console.log($1,$2,$3,$4,$5,$6); }
	| PR_DO '{' sentencias_m '}' PR_WHILE '(' expresion ')' ';' 								{ console.log($1,$2,$3,$4,$5,$6,$7,$8,$9); }
	| PR_DO '{' '}' PR_WHILE '(' expresion ')' ';' 			{ console.log($1,$2,$3,$4,$5,$6,$7,$8); }
	| PR_CONSOLE '.' PR_WRITE '(' expresion ')' ';' 		{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_RETURN expresion ';'								{ console.log($1,$2,$3); }
	| PR_RETURN ';' 										{ console.log($1,$2); }
	| PR_BREAK ';' 											{ console.log($1,$2); }
	| PR_CONTINUE ';' 										{ console.log($1,$2); }
	| PR_VOID PR_MAIN '(' ')' '{' sentencias_m '}' 			{ console.log($1,$2,$3,$4,$5,$6,$7); }
	| PR_VOID PR_MAIN '(' ')' '{' '}' 						{ console.log($1,$2,$3,$4,$5,$6); }
	| error { console.log('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column); }
;

expresion
	: expresion '&&' expresion 		{ $$ = $1 + $2 + $3; }
	| expresion '||' expresion 		{ $$ = $1 + $2 + $3; }
	| '!' expresion 				{ $$ = $1 + $2; }
	| expresion '<' expresion 		{ $$ = $1 + $2 + $3; }
	| expresion '<' '=' expresion 	{ $$ = $1 + $2 + $3 + $4; }
	| expresion '>' expresion 		{ $$ = $1 + $2 + $3; }
	| expresion '>' '=' expresion 	{ $$ = $1 + $2 + $3 + $4; }
	| expresion '=' '=' expresion 	{ $$ = $1 + $2 + $3 + $4; }
	| expresion '!' '=' expresion 	{ $$ = $1 + $2 + $3 + $4; }
	| expresion '+' expresion 		{ $$ = $1 + $2 + $3; }
	| expresion '-' expresion 		{ $$ = $1 + $2 + $3; }
	| expresion '*' expresion 		{ $$ = $1 + $2 + $3; }
	| expresion '/' expresion 		{ $$ = $1 + $2 + $3; }
	| '(' expresion ')' 			{ $$ = $1 + $2 + $3; }
	| ENTERO 						{ $$ = $1; }
	| FLOTANTE 						{ $$ = $1; }
	| CARACTER 						{ $$ = $1; }
	| CADENA 						{ $$ = $1; }
	| HTML 							{ $$ = $1; }
	| TRUE 							{ $$ = $1; }
	| FALSE 						{ $$ = $1; }
//	| ID '++' 						{ $$ = $1 + $2; }
//	| ID '--' 						{ $$ = $1 + $2; }
	| ID 							{ $$ = $1; }
;
