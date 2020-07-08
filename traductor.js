var fs = require('fs');
var parser = require('./gramatica');

const TIPO_INSTRUCCION = require('./instrucciones').TIPO_INSTRUCCION;
const TIPO_OPERACION = require('./instrucciones').TIPO_OPERACION;
const TIPO_VALOR = require('./instrucciones').TIPO_VALOR;
const TIPO_OPCION_SWITCH = require('./instrucciones').TIPO_OPCION_SWITCH;
const TIPO_PASO = require('./instrucciones').TIPO_PASO;
const API = require('./instrucciones').API;

var python = "";

let ast;

/*try{
	const entrada = fs.readFileSync('./public/entrada.txt');
	ast = parser.parse(entrada.toString());

	fs.writeFileSync('./public/ast.json', JSON.stringify(ast, null, 2));
} catch (e){
	console.error(e);
	return;
}
*/

exports.getCode = function (ast) { python = traducir("", ast); return python; };

//Procesar nodos AST
function traducir(tab, instrucciones){
	let traduccion = "";
	instrucciones.forEach(instruccion => {
		switch(instruccion.tipo){
			case TIPO_INSTRUCCION.ASIGNACION:
				break;
			case TIPO_INSTRUCCION.DECLARACION:
				break;
			case TIPO_INSTRUCCION.METODO:
				break;
			case TIPO_INSTRUCCION.FUNCION:
				break;
			case TIPO_INSTRUCCION.MAIN:
				break;
			case TIPO_INSTRUCCION.IF:
				break;
			case TIPO_INSTRUCCION.ELSE_IF:
				break;
			case TIPO_INSTRUCCION.ELSE:
				break;
			case TIPO_INSTRUCCION.SWITCH:
				break;
			case TIPO_INSTRUCCION.FOR:
				traduccion += traducirFor(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.WHILE:
				traduccion += traducirWhile(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.DO_WHILE:
				traduccion += traducirDoWhile(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.IMPRIMIR:
				traduccion += traducirImprimir(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.RETURN_E:
				traduccion += traducirReturnE(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.RETURN:
				traduccion += traducirReturn(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.BREAK:
				traduccion += traducirBreak(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.CONTINUE:
				traduccion += traducirContinue(tab,instruccion);
				break;
			case TIPO_INSTRUCCION.PARAMETRO:
				break;
		}

		/*if(instruccion.tipo === TIPO_INSTRUCCION.IMPRIMIR){
			traducirImprimir(instruccion);
		}*/
	});
	return traduccion;
}

//Traducciones
function traducirFor(tab, instruccion){

}

function traducirWhile(tab, instruccion){
	let condicion = traducirExpLogica(instruccion.condicion);
	let lista = traducir(tab + "\t", instruccion.instrucciones);
	return tab + "while "+condicion+":\n"+ lista;
}

function traducirDoWhile(tab, instruccion){
	let condicion = traducirExpLogica(instruccion.condicion);
	let lista = traducir(tab + "\t", instruccion.instrucciones);
	return tab + "while true:\n" + lista + tab + "\tif("+condicion+"):\n" + tab + "\t\tbreak\n";
}

function traducirImprimir(tab, instruccion){
	let traduccion = 'print('+ traducirExpNum(instruccion.expresion) +')';
	return tab + traduccion + "\n";
	//console.log(traduccion);
}

function traducirReturnE(tab, instruccion){
	let traduccion = 'return ' + traducirExpNum(instruccion.expresion);
	return tab + traduccion + "\n";
}

function traducirReturn(tab, instruccion){
	return tab + "return \n";
}

function traducirBreak(tab, instruccion){
	return tab + "break \n";
}

function traducirContinue(tab, instruccion){
	return tab + "continue \n";
}

function traducirExpLogica(expresion){
	let valorIzq = "";
	let valorDer = "";
	switch(expresion.tipo){
		case TIPO_OPERACION.AND:
			valorIzq = traducirExpRelacional(expresion.opIzq);
			valorDer = traducirExpRelacional(expresion.opDer);
			return valorIzq + ' and ' + valorDer;
		case TIPO_OPERACION.OR:
			valorIzq = traducirExpRelacional(expresion.opIzq);
			valorDer = traducirExpRelacional(expresion.opDer);
			return valorIzq + ' or ' + valorDer;
		case TIPO_OPERACION.NOT:
			valorIzq = traducirExpRelacional(expresion.opIzq);
			return ' not ' + valorIzq ;
		default:
			return traducirExpRelacional(expresion);
	}
}

function traducirExpRelacional(expresion){
	let valorIzq = traducirExpNum(expresion.opIzq);
	let valorDer = traducirExpNum(expresion.opDer);
	var exp = {};
	switch(expresion.tipo){
		case TIPO_OPERACION.MENOR:
			return valorIzq + ' < ' + valorDer;
		case TIPO_OPERACION.MENOR_IGUAL:
			return valorIzq + ' <= ' + valorDer;
		case TIPO_OPERACION.MAYOR:
			return valorIzq + ' > ' + valorDer;
		case TIPO_OPERACION.MAYOR_IGUAL:
			return valorIzq + ' >= ' + valorDer;
		case TIPO_OPERACION.DOBLE_IGUAL:
			return valorIzq + ' == ' + valorDer;
		case TIPO_OPERACION.DISTINTO:
			return valorIzq + ' != ' + valorDer;
	}
}

function traducirExpNum(expresion){
	//console.log(" -- " +expresion.tipo);
	let valorIzq = {};
	let valorDer = {};
	let exp = {};
	switch(expresion.tipo){
		case TIPO_OPERACION.NEGATIVO:
			exp = traducirExpNum(expresion.opIzq);
			return ' - ' + exp;
		case TIPO_OPERACION.SUMA:
			valorIzq = traducirExpNum(expresion.opIzq);
			valorDer = traducirExpNum(expresion.opDer);
			return valorIzq + ' + ' + valorDer;
		case TIPO_OPERACION.RESTA:
			valorIzq = traducirExpNum(expresion.opIzq);
			valorDer = traducirExpNum(expresion.opDer);
			return valorIzq + ' - ' + valorDer;
		case TIPO_OPERACION.MULTIPLICACION:
			valorIzq = traducirExpNum(expresion.opIzq);
			valorDer = traducirExpNum(expresion.opDer);
			return valorIzq + ' * ' + valorDer;
		case TIPO_OPERACION.DIVISION:
			valorIzq = traducirExpNum(expresion.opIzq);
			valorDer = traducirExpNum(expresion.opDer);
			return valorIzq + ' / ' + valorDer;
		case TIPO_OPERACION.AGRUPACION:
			exp = traducirExpNum(expresion.expresion);
			return '(' + exp + ')';
		case TIPO_VALOR.INT:
			return expresion.valor;
		case TIPO_VALOR.DOUBLE:
			return expresion.valor;
		case TIPO_VALOR.CHAR:
			return "'" + expresion.valor + "'";
		case TIPO_VALOR.ID:
			return expresion.valor;
		case TIPO_VALOR.STRING:
			return '"' + expresion.valor + '"';
		case TIPO_VALOR.HTML:
			return "'" + expresion.valor + "'";
		case TIPO_VALOR.TRUE:
			return expresion.valor;
		case TIPO_VALOR.FALSE:
			return expresion.valor;
	}
}