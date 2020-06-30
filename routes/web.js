const express = require('express');
const Route = express.Router();

//Rutas
Route.get('/', (req, res) =>{
	res.render('index',{title:'Inicio | CPy'});
});

Route.get('/about', (req, res) => {
	res.render('about',{title:'Acerca de | CPy'});
});

Route.get('/translate', (req, res) => {
	res.render('traductor',{title:'Traductor | CPy'});
});

module.exports = Route;