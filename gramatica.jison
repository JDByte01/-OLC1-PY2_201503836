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

[0-9]+("."[0-9]+)    		return 'FLOTANTE';
[0-9]+               		return 'ENTERO';
([a-zA-Z])[a-zA-Z0-9_]* 	return 'ID';
\'[^\']\'  					{ yytext = yytext.substr(1,yyleng-2); return 'CARACTER'; }
\'[^\']*\' 					{ yytext = yytext.substr(1,yyleng-2); return 'HTML'; }

\"[^\"]*\"							{ yytext = yytext.substr(1,yyleng-2); return 'CADENA'; }

<<EOF>>                 return 'EOF';

.   {
		//console.log('Este es un error léxico: ' + yytext + ', en la linea: ' + yylloc.first_line + ', en la columna: ' + yylloc.first_column);
		error({tipo:'Léxico', contenido: 'El caracter << ' + yytext + ' >> no pertenece al lenguaje' , fila: yylloc.first_line, columna:  yylloc.first_column });
	}

/lex

%{
	//Codigo JavaScript
	const TIPO_OPERACION = require('./instrucciones').TIPO_OPERACION;
	const TIPO_VALOR = require('./instrucciones').TIPO_VALOR;
	const API = require('./instrucciones').API;

	//Lista de errores
	var errores = [];

	function error(err){
		errores.push(err);
	}

	reporte: function getErrores () {
		var temp = errores;
		errores = [];
		return temp;
	}

	exports.reporte = function () { var temp = errores; errores = []; return temp; };

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
	: sentencias EOF { console.log(" |> AST generado..."); return $1; }
;

sentencias
	: sentencias sentencia 	{ $1.push($2); $$ = $1; }
	| sentencia 			{ $$ = [$1]; }
;

sentencia
	: tipo_dato lista_id '=' exp_num ';' 						{ $$ = API.nuevoDeclaracionA($2, $1, $4); }
	| tipo_dato lista_id ';' 									{ $$ = API.nuevoDeclaracion($2, $1); }
	| ID '=' exp_num ';'										{ $$ = API.nuevoAsignacion($1, $3); }
	| PR_VOID ID '(' parametros ')' '{' sentencias_m '}' 		{ $$ = API.nuevoMetodo($2, $4, $7); }
	| PR_VOID ID '(' parametros ')' '{' '}'						{ $$ = API.nuevoMetodo($2, $4, undefined); }
	| PR_VOID ID '(' ')' '{' sentencias_m '}' 					{ $$ = API.nuevoMetodo($2, undefined, $6); }
	| PR_VOID ID '(' ')' '{' '}'  								{ $$ = API.nuevoMetodo($2, undefined, undefined); }
	| tipo_dato ID '(' parametros ')' '{' sentencias_m '}' 		{ $$ = API.nuevoFuncion($1, $2, $4, $7); }
	| tipo_dato ID '(' parametros ')' '{' '}' 					{ $$ = API.nuevoFuncion($1, $2, $4, undefined); }
	| tipo_dato ID '(' ')' '{' sentencias_m '}' 				{ $$ = API.nuevoFuncion($1, $2, undefined, $6); }
//	| tipo_dato ID '(' ')' '{' '}' 								{ $$ = API.nuevoFuncion($1, $2, undefined, undefined); }
	| PR_IF '(' exp_logica ')' '{' sentencias_m '}' 			{ $$ = API.nuevoIf($3, $6); }
	| PR_IF '(' exp_logica ')' '{' '}' 							{ $$ = API.nuevoIf($3, undefined); }
	| PR_ELSE PR_IF '(' exp_logica ')' '{' sentencias_m '}' 	{ $$ = API.nuevoElseIf($4, $7); }
	| PR_ELSE PR_IF '(' exp_logica ')' '{' '}'					{ $$ = API.nuevoElseIf($4, undefined); }
	| PR_ELSE '{' sentencias_m '}' 								{ $$ = API.nuevoElse($3); }
	| PR_ELSE '{' '}' 											{ $$ = API.nuevoElse(undefined); }
	| PR_SWITCH '(' exp_num ')' '{' lista_case '}' 				{ $$ = API.nuevoSwitch($3, $6); }
	| PR_FOR '(' tipo_dato ID '=' exp_num ';' exp_logica ';' paso ')' '{' sentencias_m '}' 	{ $$ = API.nuevoFor($4, $6, $8, $10, $13, $3); }
	| PR_FOR '(' tipo_dato ID '=' exp_num ';' exp_logica ';' paso ')' '{' '}'				{ $$ = API.nuevoFor($4, $6, $8, $10, undefined, $3); }
	| PR_FOR '(' ID '=' exp_num ';' exp_logica ';' paso ')' '{' sentencias_m '}' 			{ $$ = API.nuevoFor($3, $5, $7, $11, $12, undefined); }
	| PR_FOR '(' ID '=' exp_num ';' exp_logica ';' paso ')' '{' '}' 						{ $$ = API.nuevoFor($3, $5, $7, $11, undefined, undefined); }
	| PR_WHILE '(' exp_logica ')' '{' sentencias_m '}' 										{ $$ = API.nuevoWhile($3, $6); }
	| PR_WHILE '(' exp_logica ')' '{' '}' 													{ $$ = API.nuevoWhile($3, undefined); }
	| PR_DO '{' sentencias_m '}' PR_WHILE '(' exp_logica ')' ';' 							{ $$ = API.nuevoDoWhile($7, $3); }
	| PR_DO '{' '}' PR_WHILE '(' exp_logica ')' ';' 										{ $$ = API.nuevoDoWhile($6, undefined); }
	| PR_CONSOLE '.' PR_WRITE '(' exp_num ')' ';' 			{ $$ = API.nuevoImprimir($5); }
	| PR_RETURN exp_num ';'									{ $$ = API.nuevoReturnE($2); }
	| PR_RETURN ';' 										{ $$ = API.nuevoReturn(); }
	| PR_BREAK ';' 											{ $$ = API.nuevoBreak(); }
	| PR_CONTINUE ';' 										{ $$ = API.nuevoContinue(); }
	| PR_VOID PR_MAIN '(' ')' '{' sentencias_m '}' 			{ $$ = API.nuevoMain($6); }
	| PR_VOID PR_MAIN '(' ')' '{' '}' 						{ $$ = API.nuevoMain(undefined); }
	| error {
				//console.log('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);
				error({tipo:'Sintactico', contenido: 'Se esperava [ ; | } | Terminal ] , se encontró: << ' + yytext + ' >>' , fila: this._$.first_line, columna:  this._$.first_column })
			}
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
	| ID 				{ $$ = API.nuevoListaIds($1); }
;

parametros
	: parametros ',' parametro 	{ $1.push($3); $$ = $1; }
	| parametro 				{ $$ = API.nuevoListaParametro($1); }
;

parametro
	: tipo_dato ID { $$ = API.nuevoParametro($1, $2); }
;

/*
else_if
	: else_if elif 	{ $1.push($2); $$ = $1; }
	| elif 			{ $$ = [$1]; }
;

elif
	: PR_ELSE PR_IF '(' exp_logica ')' '{' sentencias_m '}' 	{ $$ = API.nuevoElseIf($4, $7); }
	| PR_ELSE PR_IF '(' exp_logica ')' '{' '}'					{ $$ = API.nuevoElseIf($4, undefined); }
	| PR_ELSE '{' sentencias_m '}' 								{ $$ = API.nuevoElse($3); }
	| PR_ELSE '{' '}' 											{ $$ = API.nuevoElse(undefined); }
;
*/

lista_case
	: lista_case case 	{ $1.push($2); $$ = $1; }
	| case 				{ $$ = API.nuevoListaCase($1); }
;

case
	: PR_CASE exp_num ':' sentencias_m 	{ $$ = API.nuevoCase($2, $4); }
	| PR_DEFAULT ':' sentencias_m 		{ $$ = API.nuevoDefault($3); }
;

paso
	: ID '+' '+' 	{ $$ = API.nuevoIncremento($1); }
	| ID '-' '-' 	{ $$ = API.nuevoDecremento($1); }
;

sentencias_m
	: sentencias_m sentencia_m 	{ $1.push($2); $$ = $1; }
	| sentencia_m 				{ $$ = [$1]; }
;

sentencia_m
	: tipo_dato lista_id '=' exp_num ';' 						{ $$ = API.nuevoDeclaracionA($2, $1, $4); }
	| tipo_dato lista_id ';' 									{ $$ = API.nuevoDeclaracion($2, $1); }
	| ID '=' exp_num ';'										{ $$ = API.nuevoAsignacion($1, $3); }
	| PR_IF '(' exp_logica ')' '{' sentencias_m '}' 			{ $$ = API.nuevoIf($3, $6); }
	| PR_IF '(' exp_logica ')' '{' '}' 							{ $$ = API.nuevoIf($3, undefined); }
	| PR_ELSE PR_IF '(' exp_logica ')' '{' sentencias_m '}' 	{ $$ = API.nuevoElseIf($4, $7); }
	| PR_ELSE PR_IF '(' exp_logica ')' '{' '}'					{ $$ = API.nuevoElseIf($4, undefined); }
	| PR_ELSE '{' sentencias_m '}' 								{ $$ = API.nuevoElse($3); }
	| PR_ELSE '{' '}' 											{ $$ = API.nuevoElse(undefined); }
	| PR_SWITCH '(' exp_num ')' '{' lista_case '}' 				{ $$ = API.nuevoSwitch($3, $6); }
	| PR_FOR '(' tipo_dato ID '=' exp_num ';' exp_logica ';' paso ')' '{' sentencias_m '}' 	{ $$ = API.nuevoFor($4, $6, $8, $10, $13, $3); }
	| PR_FOR '(' tipo_dato ID '=' exp_num ';' exp_logica ';' paso ')' '{' '}'				{ $$ = API.nuevoFor($4, $6, $8, $10, undefined, $3); }
	| PR_FOR '(' ID '=' exp_num ';' exp_logica ';' paso ')' '{' sentencias_m '}' 			{ $$ = API.nuevoFor($3, $5, $7, $11, $12, undefined); }
	| PR_FOR '(' ID '=' exp_num ';' exp_logica ';' paso ')' '{' '}' 						{ $$ = API.nuevoFor($3, $5, $7, $11, undefined, undefined); }
	| PR_WHILE '(' exp_logica ')' '{' sentencias_m '}' 										{ $$ = API.nuevoWhile($3, $6); }
	| PR_WHILE '(' exp_logica ')' '{' '}' 													{ $$ = API.nuevoWhile($3, undefined); }
	| PR_DO '{' sentencias_m '}' PR_WHILE '(' exp_logica ')' ';' 							{ $$ = API.nuevoDoWhile($7, $3); }
	| PR_DO '{' '}' PR_WHILE '(' exp_logica ')' ';' 										{ $$ = API.nuevoDoWhile($6, undefined); }
	| PR_CONSOLE '.' PR_WRITE '(' exp_num ')' ';' 			{ $$ = API.nuevoImprimir($5); }
	| PR_RETURN exp_num ';'									{ $$ = API.nuevoReturnE($2); }
	| PR_RETURN ';' 										{ $$ = API.nuevoReturn(); }
	| PR_BREAK ';' 											{ $$ = API.nuevoBreak(); }
	| PR_CONTINUE ';' 										{ $$ = API.nuevoContinue(); }
	| error {
				//console.log('Este es un error sintáctico: ' + yytext + ', en la linea: ' + this._$.first_line + ', en la columna: ' + this._$.first_column);
				error({tipo:'Sintactico', contenido: 'Se esperava [ ; | } | Terminal ] , se encontró: << ' + yytext + ' >>' , fila: this._$.first_line, columna:  this._$.first_column })
			}
;

exp_logica
	: exp_relacional '&&' exp_relacional 	{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.AND); }
	| exp_relacional '||' exp_relacional 	{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.OR); }
	| '!' exp_relacional 					{ $$ = API.nuevoOperacionUnaria($2, TIPO_OPERACION.NOT); }
	| exp_relacional						{ $$ = $1; }
//	| TRUE 									{ $$ = API.nuevoValor($1, TIPO_VALOR.BOOL); }
//	| FALSE 								{ $$ = API.nuevoValor($1, TIPO_VALOR.BOOL); }
;

exp_relacional
	: exp_num '<' exp_num 				{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.MENOR); }
	| exp_num '<' '=' exp_num 			{ $$ = API.nuevoOperacionBinaria($1, $4, TIPO_OPERACION.MENOR_IGUAL); }
	| exp_num '>' exp_num 				{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.MAYOR); }
	| exp_num '>' '=' exp_num 			{ $$ = API.nuevoOperacionBinaria($1, $4, TIPO_OPERACION.MAYOR_IGUAL); }
	| exp_num '=' '=' exp_num 			{ $$ = API.nuevoOperacionBinaria($1, $4, TIPO_OPERACION.DOBLE_IGUAL); }
	| exp_num '!' '=' exp_num 			{ $$ = API.nuevoOperacionBinaria($1, $4, TIPO_OPERACION.DISTINTO); }
	| exp_num							{ $$ = $1; }
;

/*
exp_cadena
	: exp_cadena '+' exp_cadena     { $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.CONCATENACION); }
	| CADENA 						{ $$ = API.nuevoValor($1, TIPO_VALOR.STRING); }
	| CARACTER 						{ $$ = API.nuevoValor($1, TIPO_VALOR.CHAR); }
	| HTML 							{ $$ = API.nuevoValor($1, TIPO_VALOR.HTML); }
	| exp_num						{ $$ = $1; }
;*/

exp_num
	: '-' exp_num %prec UMENOS	{ $$ = API.nuevoOperacionUnaria($2, TIPO_OPERACION.NEGATIVO); }
	| exp_num '+' exp_num 		{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.SUMA); }
	| exp_num '-' exp_num 		{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.RESTA); }
	| exp_num '*' exp_num 		{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.MULTIPLICACION); }
	| exp_num '/' exp_num 		{ $$ = API.nuevoOperacionBinaria($1, $3, TIPO_OPERACION.DIVISION); }
	| '(' exp_num ')' 			{ $$ = $2; }
	| ENTERO 					{ $$ = API.nuevoValor(Number($1), TIPO_VALOR.INT); }
	| FLOTANTE 					{ $$ = API.nuevoValor(Number($1), TIPO_VALOR.DOUBLE); }
	| CARACTER 					{ $$ = API.nuevoValor($1, TIPO_VALOR.CHAR); }
	| CADENA 					{ $$ = API.nuevoValor($1, TIPO_VALOR.STRING); }
	| HTML 						{ $$ = API.nuevoValor($1, TIPO_VALOR.HTML); }
	| TRUE 						{ $$ = API.nuevoValor($1, TIPO_VALOR.BOOL); }
	| FALSE 					{ $$ = API.nuevoValor($1, TIPO_VALOR.BOOL); }
	| ID 						{ $$ = API.nuevoValor($1, TIPO_VALOR.ID); }
;