const express = require('express');
const Route = express.Router();

var parser = require("./../gramatica").parser;

var nombreArchivo = "Untitle"
var txtEntrada = "";
var txtSalida = "";
var tablaId;
var txtHtml = "";
var txtJson = "";
var tablaErrores;

//Funciones
function exec (input) {
    return parser.parse(input);
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
      tabTitle: nombreArchivo
    }
  );
});

Route.post('/translate', (req, res) => {
  let txt = req.body.entrada;
  res.send(exec(txt));
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