const TIPO_VALOR = {
	INT: 	'VAL_INT',
	DOUBLE: 'VAL_DOUBLE',
	CHAR: 	'VAL_CHAR',
	BOOL: 	'VAL_BOOL',
	STRING: 'VAL_STRING',
	ID: 	'VAL_ID',
	HTML: 	'HTML'
}

const TIPO_OPERACION = {
	SUMA: 			'OP_SUMA',
	RESTA: 			'OP_RESTA',
	MULTIPLICACION: 'OP_MULTIPLICACION',
	DIVISION: 		'OP_DIVISION',
	AND: 			'OP_AND',
	OR: 			'OP_OR',
	NOT: 			'OP_NOT',
	MAYOR: 			'OP_MAYOR',
	MENOR: 			'OP_MENOR',
	MAYOR_IGUAL: 	'OP_MAYOR_IGUAL',
	MENOR_IGUAL: 	'OP_MENOR_IGUAL',
	DOBLE_IGUAL: 	'OP_DOBLE_IGUAL',
	DISTINTO: 		'OP_DISTINTO',
	NEGATIVO: 		'OP_NEGATIVO',
	CONCATENACION: 	'OP_CONCATENACION'
}

const TIPO_INSTRUCCION = {
	ASIGNACION: 	'IN_ASIGNACION',
	DECLARACION: 	'IN_DECLARACION',
	METODO: 		'IN_METODO',
	FUNCION: 		'IN_FUNCION',
	MAIN: 			'IN_MAIN',
	IF: 			'IN_IF',
	ELSE_IF: 		'IN_ELSE_IF',
	ELSE: 			'IN_ELSE',
	SWITCH: 		'IN_SWITCH',
	FOR: 			'IN_FOR',
	WHILE: 			'IN_WHILE',
	DO_WHILE: 		'IN_DO_WHILE',
	IMPRIMIR: 		'IN_IMPRIMIR',
	RETURN: 		'IN_RETURN',
	BREAK: 			'IN_BREAK',
	CONTINUE: 		'IN_CONTINUE',
	PARAMETRO: 		'PARAMETRO'
}

const TIPO_OPCION_SWITCH = {
	CASO: 		'CASO',
	DEFAULT: 	'DEFAULT'
}

const TIPO_PASO = {
	INCREMENTO: 'INCREMENTO',
	DECREMENTO: 'DECREMENTO'
}

function newOperacion(opIzq, opDer, tipo){
	return {
		opIzq: opIzq,
		opDer: opDer,
		tipo: tipo
	}
}

// Traductor

const API = {
	nuevoOperacionBinaria: function(opIzq, opDer, tipo){
		return newOperacion(opIzq, opDer, tipo);
//		return {
//			opIzq: opIzq,
//			opDer: opDer,
//			tipo: tipo
//		}
	},

	nuevoOperacionUnaria: function(op, tipo){
		return newOperacion(op, undefined, tipo);
//		return {
//			opIzq: op,
//			tipo: tipo
//		}
	},

	nuevoValor: function(valor, tipo){
		return {
			tipo: tipo,
			valor: valor
		}
	},

	//=================================================

	//Declaración y asignación de variables
	//Declaración: tipo l_id ;
	nuevoDeclaracion: function(l_id, tipo){
		return {
			tipo: TIPO_INSTRUCCION.DECLARACION,
			identificadores: l_id,
			tipo_dato: tipo
		}
	},

	//Declaración: tipo l_id = exp ;
	nuevoDeclaracionA: function(l_id, tipo, exp){
		return {
			tipo: TIPO_INSTRUCCION.DECLARACION,
			identificadores: l_id,
			tipo_dato: tipo,
			expresion: exp
		}
	},

	//lista de ID's
	nuevoListaIds: function(id){
		var ids = [];
		ids.push(id);
		return ids;
	},

	//Asignación:  id = exp ;
	nuevoAsignacion: function(id, exp){
		return {
			tipo: TIPO_INSTRUCCION.ASIGNACION,
			identificador: id,
			expresion: exp
		}
	},

	//Métodos y Funciones
	//VOID id ( parametros ) { instrucciones }
	nuevoMetodo: function(id, parametros, instrucciones){
		return{
			tipo: TIPO_INSTRUCCION.METODO,
			identificador: id,
			parametros: parametros,
			instrucciones, instrucciones
		}
	},

	//tipo id ( parametros ) { instrucciones }
	nuevoFuncion: function(tipo, id, parametros, instrucciones){
		return{
			tipo: TIPO_INSTRUCCION.FUNCION,
			identificador: id,
			tipo_dato: tipo,
			parametros: parametros,
			instrucciones, instrucciones
		}
	},

	//Lista Parametros
	nuevoListaParametro: function(parametro){
		var parametros = [];
		parametros.push(parametro);
		return parametros;
	},

	//Parametro tipo id
	nuevoParametro: function(tipo, id){
		return{
			tipo: TIPO_INSTRUCCION.PARAMETRO,
			identificador: id,
			tipo_dato: tipo
		}
	},

	//VOID MAIN ( ) { instrucciones }
	nuevoMain: function(instrucciones){
		return{
			tipo: TIPO_INSTRUCCION.MAIN,
			instrucciones: instrucciones
		}
	},

	//Sentencia IF - sin jerarquía
	// IF ( condicion ) { instrucciones }
	nuevoIf: function(condicion, instrucciones){
		return {
			tipo: TIPO_INSTRUCCION.IF,
			condicion: condicion,
			instrucciones: instrucciones
		}
	},

	// ELSE IF ( condicion ) { instrucciones }
	nuevoElseIf: function(condicion, instrucciones){
		return{
			tipo: TIPO_INSTRUCCION.ELSE_IF,
			condicion: condicion,
			instrucciones: instrucciones
		}
	},

	// ELSE { instrucciones }
	nuevoElse: function(instrucciones){
		return{
			tipo: TIPO_INSTRUCCION.ELSE,
			instrucciones: instrucciones
		}
	},

	//Sentencia SWITCH
	//SWITCH ( condicion ) { l_case }
	nuevoSwitch: function(condicion, l_case){
		return {
			tipo: TIPO_INSTRUCCION.SWITCH,
			condicion: condicion,
			casos: l_case
		}
	},

	//Lista de casos
	nuevoListaCase: function(caso){
		var l_case = [];
		l_case.push(caso);

		return l_case;
	},

	//CASE condicion : instrucciones
	nuevoCase: function(condicion, instrucciones){
		return{
			tipo: TIPO_OPCION_SWITCH.CASE,
			condicion: condicion,
			instrucciones: instrucciones
		}
	},

	//DEFAULT : instrucciones
	nuevoDefault: function(instrucciones){
		return{
			tipo: TIPO_OPCION_SWITCH.DEFAULT,
			instrucciones: instrucciones
		}
	},

	//FOR
	//FOR ( variable = valor; condicion; aumento ) { instrucciones }
	nuevoFor: function(variable, valor, condicion, paso, instrucciones, tipo){
		return {
			tipo: TIPO_INSTRUCCION.FOR,
			condicion: condicion,
			instrucciones: instrucciones,
			paso: paso,
			variable: variable,
			valorVariable: valor,
			tipo_dato: tipo
		}
	},

	//WHILE
	//WHILE ( condicion ) { instrucciones }
	nuevoWhile: function(condicion, instrucciones){
		return {
			tipo: TIPO_INSTRUCCION.WHILE,
			condicion: condicion,
			instrucciones: instrucciones
		};
	},

	//DO-WHILE
	//DO { instrucciones } WHILE ( condicion ) ;
	nuevoDoWhile: function(condicion, instrucciones){
		return{
			tipo: TIPO_INSTRUCCION.DO_WHILE,
			condicion: condicion,
			instrucciones: instrucciones
		}
	},

	//IMPRIMIR
	//CONSOLE . WRITE ( exp ) ;
	nuevoImprimir: function(exp){
		return {
			tipo: TIPO_INSTRUCCION.IMPRIMIR,
			expresion: exp
		};
	},

	//RETURN
	//RETURN exp ;
	nuevoReturnE: function(exp){
		return {
			tipo: TIPO_INSTRUCCION.RETURN,
			expresion: exp
		}
	},

	//RETURN  ;
	nuevoReturn: function(){
		return {
			tipo: TIPO_INSTRUCCION.RETURN
		}
	},

	//BREAK
	//BREAK;
	nuevoBreak: function(){
		return {
			tipo: TIPO_INSTRUCCION.BREAK
		}
	},

	//CONTINUE
	//CONTINUE;
	nuevoContinue: function(){
		return {
			tipo: TIPO_INSTRUCCION.CONTINUE
		}
	},

	//Operadores Lógicos, aritméticos y comparativos
	nuevoOperador: function(operador){
		return operador
	},

	//Paso for
	//Incremento id ++ ;
	nuevoIncremento: function(id){
		return{
			tipo: TIPO_PASO.INCREMENTO,
			identificador: id
		}
	},

	//Decremento id -- ;
	nuevoDecremento: function(id){
		return{
			tipo: TIPO_PASO.DECREMENTO,
			identificador: id
		}
	}
}

//Exportar constantes

module.exports.TIPO_INSTRUCCION = TIPO_INSTRUCCION;
module.exports.TIPO_OPERACION = TIPO_OPERACION;
module.exports.TIPO_VALOR = TIPO_VALOR;
module.exports.TIPO_OPCION_SWITCH = TIPO_OPCION_SWITCH;
module.exports.API = API;