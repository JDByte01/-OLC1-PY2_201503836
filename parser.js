var fs = require('fs');
var parser = require('./gramatica');

fs.readFile('./public/entrada.txt', (err, data) =>{
	if(err) throw err;
	parser.parse(data.toString());
	console.log(" Lista de Errores: ",parser.reporte());
});