var length = process.argv.length;
if (length < 4){
    console.log("Erro:not enough arguments.");
    console.log('Usage: node server.js IPAdress portnumber');
    process.exit(1);
}

var ip = process.argv[2];
var port = process.argv[3];
var express = require('express'),
var app = express();
var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : 'dynamicpricing.c0awghzunzra.us-east-1.rds.amazonaws.com',
  user     : 'cloud',
  password : 'dynamicpricing',
  port     : '3306'

});

connection.connect(function(err){
  if(err){
    console.log('Error connecting to DB');
    return;
  }
  console.log('Connection to DB established');
});






//===============ROUTES===============
app.get('/signin', function (req, res) {
    /*
     * get the username  and password
     *
    */
    var user = {
        username: req.body.username,
        password: req.body.password
    };
    connection.qurery('SEECT * FROM')


    // put the usernmae and password into the db
    connection.query('INSERT INTO user SET ?', employee, function(err,res){
        if(err) throw err;
        console.log('Last insert ID:', res.insertId);

    });


});

app.get('/login', function(req, res)){

});

app.get('/forgetkey', function(req,res)){

});

app.get('/profile', function(req,res)){

});


app.get('/scan',function(req,res)){

});

app.get('/bid',function(req,res)){

});

app.get('/amazon', function(req,res)){

});







var listenPort =  process.env.PORT|| 8081;
var server = app.listen(listenPort);
console.log("listening on " + port + "!");
