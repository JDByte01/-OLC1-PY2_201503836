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

try{
	const entrada = fs.readFileSync('./public/entrada.txt');
	ast = parser.parse(entrada.toString());

	fs.writeFileSync('./public/ast.json', JSON.stringify(ast, null, 2));
} catch (e){
	console.error(e);
	return;
}

//Procesar nodos AST
traducir(ast);

function traducir(instrucciones){
	instrucciones.forEach(instruccion => {
		if(instruccion.tipo === TIPO_INSTRUCCION.IMPRIMIR){
			traducirImprimir(instruccion);
		}
	});
}

//Traducciones
function traducirImprimir(instruccion){
	const traduccion = 'print('+ traducirExpNum(instruccion.expresion) +')';
	console.log(traduccion);
}

function traducirExpNum(expresion){
	//console.log(" -- " +expresion.tipo);

	switch(expresion.tipo){
		case TIPO_OPERACION.NEGATIVO:
			const exp = traducirExpNum(expresion.opIzq);
			return ' - ' + exp;
		case TIPO_OPERACION.SUMA:
			const valorIzq = traducirExpNum(expresion.opIzq);
			const valorDer = traducirExpNum(expresion.opDer);
			return valorIzq + ' + ' + valorDer;
		case TIPO_VALOR.ID:
			return expresion.valor;
		case TIPO_VALOR.STRING:
			return '"' + expresion.valor + '"';
	}
}