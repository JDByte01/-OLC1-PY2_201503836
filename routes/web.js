const express = require('express');
const Route = express.Router();

var parser = require("./../gramatica");

var nombreArchivo = "Untitle"
var txtEntrada = "";
var txtSalida = "";
var tablaId;
var txtHtml = "";
var txtJson = "";
var tablaErrores = [];
var temp;

//Funciones
function exec (input) {
    temp = parser.parse(input);
    tablaErrores = parser.reporte();
    console.log(tablaErrores);
    return temp;
}

//Rutas
Route.get('/', (req, res) =>{
	res.render('index',{title:'Inicio | CPy',navItem:'home'});
});

Route.get('/about', (req, res) => {
	res.render('about',{title:'Acerca de | CPy',navItem:'about'});
});

Route.get('/translate', (req, res) => {
	res.render('traductor',
    {
      title:'Traductor | CPy',
      navItem:'translate',
      tabTitle: nombreArchivo,
      txtIn: "",
      errores: []
    }
  );
});

Route.post('/translate', (req, res) => {
  let txt = req.body.entrada;
  txtEntrada = txt;
  exec(txt);
  //res.send(exec(txt));
  //res.location('back');
  res.render('traductor',
    {
      title:'Traductor | CPy',
      navItem:'translate',
      tabTitle: nombreArchivo,
      txtIn: txtEntrada,
      errores: tablaErrores
    }
  );
});

module.exports = Route;

//Comentario

/*
app.route('/book')
  .get(function(req, res) {
    res.send('Get a random book');
  })
  .post(function(req, res) {
    res.send('Add a book');
  })
  .put(function(req, res) {
    res.send('Update the book');
  });
*/