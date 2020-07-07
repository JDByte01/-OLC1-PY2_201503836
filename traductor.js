var fs = require('fs');
var parser = require('./gramatica');

const TIPO_INSTRUCCION = require('./instrucciones').TIPO_INSTRUCCION;
const TIPO_OPERACION = require('./instrucciones').TIPO_OPERACION;
const TIPO_VALOR = require('./instrucciones').TIPO_VALOR;
const TIPO_OPCION_SWITCH = require('./instrucciones').TIPO_OPCION_SWITCH;
const TIPO_PASO = require('./instrucciones').TIPO_PASO;
const API = require('./instrucciones').API;