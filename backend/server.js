// var length = process.argv.length;
// if (length < 4){
//     console.log("Erro:not enough arguments.");
//     console.log('Usage: node server.js IPAdress portnumber');
//     process.exit(1);
// }
//
// var ip = process.argv[2];
// var port = process.argv[3];
var express = require('express');
var app = express();
var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : 'dynamicpricing.c0awghzunzra.us-east-1.rds.amazonaws.com',
  user     : 'cloud',
  password : 'dynamicpricing',
  port     : '3306',
  database : 'dynamicpricing',

});

connection.connect(function(err){
  if(err){
    console.log('Error connecting to DB');
    return;
  }
  console.log('Connection to DB established');
});




// test_CDNN
connection.query({
    sql: 'SELECT * FROM business WHERE b_name = ?',
    values: ['macys']

}, function(err, res,fields){
    if(err) console.log(err);
    else console.log( res[0]["b_id"]);
});


// var user = {
//     username: 'john',
//     password: '123'
// };
//
// connection.query({
//     sql: 'SELECT * FROM user WHERE username= ? AND password = ?',
//     values:[user['username'],user['password']],
// }, function(err, res,fields){
//       if(err) console.log(err);
//       else if (res.length != 0){
//           console.log('Accepted')
//           //response.sendStatus(202);
//       }else{
//           console.log('Not accepted')
//           //response.senStatus(406);
//       }
// });


//===============ROUTES===============
app.get('/signup', function (req, response) {
    /*
     * get the username  and password
     *
    */
    var user = {
        username: req.body.username,
        password: req.body.password
    };
    connection.query({
        sql: 'SELECT * FROM user WHERE username= ?',
        values:[user['username']],
    }, function(err, res,fields){
        if(err){
            console.log(err);
            response.sendStatus(500);
        } else if (res.length != 0){
              response.sendStatus(406);
          }else{
              connection.query('INSERT INTO user SET ?', user,function(err,res){
                  if(err) console.log(err);
                  console.log('Last insert ID:', res.insertId);
                  response.sendStatus(202);
              });
          }
    });



});

app.get('/login', function(req, response){
    var user = {
        username: req.body.username,
        password: req.body.password
    };
    connection.query({
        sql: 'SELECT * FROM user WHERE username= ? AND password = ?',
        values:[user['username'],user['password']],
    }, function(err, res,fields){
          if(err){
              console.log(err);
              response.sendStatus(500);
          }
          else if (res.length != 0){
              response.sendStatus(202);
          }else{
              response.senStatus(406);
          }
    });

});


app.get('/profile', function(req,resonse){
    var username = req.body.username;
    connection.query({
        sql: 'SELECT * FROM history WHERE username= ?',
        values:[username],
    }, function(err, res,fields){
            if(err){
                console.log(err);
                response.sendStatus(500);
            }else{
                response.send(res);
            }
    });
});


app.get('/scan',function(req,response){
    connection.query({
        sql: 'SELECT b_id FROM business WHERE b_name= ?',
        values:[req.body.businessname],
    }, function(err, res,fields){
        if(err){
            console.log(err);
            response.sendStatus(500);
        } else if (res.length == 0){
              response.sendStatus(404);
        }else{
              connection.query({
                  sql: 'SELECT price FROM buy WHERE b_id= ? AND itemid = ?',
                  values:[res[0]["b_id"],req.body.barcode],
              }, function(err, result,fields){
                  if(err){
                      console.log(err);
                      response.sendStatus(500);
                  } else if (res.length == 0){
                        response.sendStatus(404);
                  }else{

                      response.status(200).send(result[0]["price"]);
                  }
              });

          }
    });
});

app.get('/bid',function(req,res){

});

app.get('/amazon', function(req,res){

});







var listenPort =  process.env.PORT|| 8081;
var server = app.listen(listenPort);
// console.log("listening on " + port + "!");
