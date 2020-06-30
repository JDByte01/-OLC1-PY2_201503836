//Required
const express = require('express');
const app = express();
const path = require('path');
const routes = require('./routes/web');

//Settings
app.set('port', 3000);
app.set('views','resources/views');
app.set('view engine', 'ejs');

//Static files

//Function's


//URL's
app.use(routes);

//Servidor Start
app.listen(app.get('port'), function(err){
	if(!err){
		console.log('Servidor corriendo en puerto: ', app.get('port'));
	} else {
		console.log('Error: ', JSON.stringify(err));
	}
});