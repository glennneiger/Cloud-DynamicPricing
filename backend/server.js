var length = process.argv.length;
var host = 'dynamicpricing.c0awghzunzra.us-east-1.rds.amazonaws.com';
var port = '3306';
var user = 'cloud';
var password = 'dynamicpricing';
var database = 'dynamicpricing';
var TIME_PENALTY = 24; // Number of hours to stop user from retry bidding
if (length == 3){
    host = process.argv[2];
}else if (length == 7){
    host = process.argv[2];
    port = process.argv[3]
    user = process.argv[4];
    password = process.argv[5];
    database = process.argv[6];
}else if ( length !=2 ){
    console.log("Erro:not enough arguments.");
    console.log('Usage: node server.js IPAdress portnumber');
    process.exit(1);
}


var express = require('express');
var app = express();
var mysql      = require('mysql');
var connection = mysql.createConnection({
  host     : host,
  user     : user,
  password : password,
  port     : port,
  database : database,
});

connection.connect(function(err){
  if(err){
    console.log('Error connecting to DB');
    return;
  }
  console.log('Connection to DB established');
});




// test_CDNN
// a =connection.query({
//     sql: 'SELECT time FROM history  WHERE DATE_SUB(NOW(),INTERVAL ? HOUR) > time',
//     values:[TIME_PENALTY],
// },function(err,res,fields){
//     if (res.length==0){
//         console.log("No result match!");
//     }
//     else console.log( res[0]["time"]);
//
// });
// console.log(typeof(a));


// connection.query({
//     sql: 'SELECT b_name,b_id FROM business WHERE b_name = ?',
//     values: ['macys']
//
// }, function(err, res,fields){
//     if(err) console.log(err);
//     else console.log( res);
//     console.log(fields);
// });



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
    console.log(req.body);
    var user = {
        username: req.body.username,
        password: req.body.password
    };
    // check whether the username has been used
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
              // insert the username and password into data base
              connection.query('INSERT INTO user SET ?', user,function(err,res){
                  if(err) console.log(err);
                  console.log('Last insert ID:', res.insertId);
                  response.sendStatus(202);
              });
          }
    });



});

app.get('/login', function(req, response){
    console.log(req.body);
    var user = {
        username: req.body.username,
        password: req.body.password
    };
    // check the username and password
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
    console.log(req.body);
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
    console.log(req.body);
    var bid = 0;
    var itemid = req.body.barcode;
    var username = req.body.username;
    // get  the bid by the business id
    connection.query({
        sql: 'SELECT b_id FROM business WHERE b_name= ?',
        values:[req.body.businessname],
    }, function(err, bid_res,fields){
        if(err){
            console.log(err);
            response.sendStatus(500);
        } else if (bid_res.length == 0){
            response.sendStatus(404);
        }else{
            // check whether the item is under dynamic pricing
            bid = bid_res[0]["b_id"];
            connection.query({
                sql: 'SELECT price FROM buy WHERE bid= ? AND itemid =?',
                values:[bid,itemid]
            },function(err,buy_res,fields){
                if(err){
                    console.log(err);
                    response.sendStatus(500);
                } else if (buy_res.length == 0){
                    response.sendStatus(406);
                }else{
                    //check whether the user is eligible for bidding
                    connection.query({
                        sql: 'SELECT time FROM history WHERE username=? AND bid=? AND iid=? AND DATE_SUB(NOW(),INTERVAL ? HOUR) < time',
                        values:[username,bid,itemid,TIME_PENALTY]
                    },function(err, time_res, fields){
                        if(err){
                            console.log(err);
                            response.sendStatus(500);
                        } else if (time_res.length != 0){
                            response.sendStatus(403);
                        }else{

                            //get the description from buy
                            connection.query({
                                sql: 'SELECT itemname, description, price FROM buy WHERE itemid = ? AND bid =?',
                                values:[itemid,bid],
                            }, function(err, desp_res,fields){
                                if(err){
                                    console.log(err);
                                    response.sendStatus(500);
                                }else if (desp_res.length== 0){
                                    response.sendStatus(500);
                                }else{
                                    reponse.send(desp_res);
                                }// endd else
                            });// end query  of descripton

                        }// end else
                    });// end  query of time

                }  // end else
            });// end query of buy
        }// end else
    });// end query of bid

});// end scan function

app.get('/bid',function(req,res){
    console.log(req.body);
    var bid_price = req.body.bid_price;
    var itemid = req.body.barcode;
    var username = req.body.username;
    var bid = 0;
    // get  the bid by the business id
    connection.query({
        sql: 'SELECT b_id FROM business WHERE b_name= ?',
        values:[req.body.businessname],
    }, function(err, bid_res,fields){
        if(err){
            console.log(err);
            response.sendStatus(500);
        } else if (bid_res.length == 0){
            response.sendStatus(404);
        }else{
            bid = bid_res[0]["b_id"];
            connection.query({
                sql: 'INSERT INTO history  VALUES (?, ?, ?, ?, NOW()',
                values:[username, bid, itemid, bid_price],
            }, function(err, insert_res,fields){
                if (err){
                    console.log(err);
                    response.sendStatus(500);
                }else{
                    response.sendStatus(202);
                }// end else
            });  // end query of insert
        }// end else
    });// end query of find bid
});

app.get('/amazon', function(req,res){

});







var listenPort =  process.env.PORT|| 8081;
var server = app.listen(listenPort);
// console.log("listening on " + port + "!");
