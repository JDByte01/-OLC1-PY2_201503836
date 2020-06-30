//Required
const express = require('express');
const path = require('path');

const app = express();
const routes = require('./routes/web');

//Settings
app.set('port', 3000);
app.set('views','resources/views');
app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname,'public')));

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