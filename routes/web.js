const express = require('express');
const Route = express.Router();

var parser = require("./../gramatica");
var translate = require("./../traductor");
var fs = require('fs');

var nombreArchivo = "Untitle"
var txtEntrada = "";
var txtSalida = "";
var tablaId;
var txtHtml = "";
var txtJson = "";
var tablaErrores = [];
var ast;

//Funciones
function exec (input) {
  try{
    ast = parser.parse(input);
    tablaErrores = parser.reporte();
    tablaId = parser.tablaVar();
    txtHtml = parser.docHtml();
    txtJson = getJSON(txtHtml);
    txtSalida = translate.getCode(ast);
    fs.writeFileSync('./public/ast.json', JSON.stringify(ast, null, 2));
  } catch (e){
    console.error(e);
    return;
  }
  console.log(tablaErrores);
  console.log(tablaId);
  console.log(txtHtml);
  console.log(txtJson);
  console.log(txtSalida);
  return ast;

}

function getJSON(txt){
  //var parser = Components.classes["@mozilla.org/xmlextras/domparser;1"]
  //           .createInstance(Components.interfaces.nsIDOMParser);
  //var doc = parser.parseFromString(txt, "application/xml");
//  var temp = DOM(txt);
  //console.log(doc);
  //var html = doc.outerHTML;
  var html = txt;
  var data = { html: html};
  console.log(txt);
  return JSON.stringify(data);
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
      txtOut: "",
      html: "",
      json: "",
      errores: [],
      variables: []
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
      txtOut: txtSalida,
      html: txtHtml,
      json: txtJson,
      errores: tablaErrores,
      variables: tablaId
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