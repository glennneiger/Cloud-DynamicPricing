var length = process.argv.length;
var host = 'dynamicpricing.c0awghzunzra.us-east-1.rds.amazonaws.com';
var port = '3306';
var user = 'cloud';
var password = 'dynamicpricing';
var database = 'dynamicpricing';
// var qr = require('qr-image');
var nodemailer = require('nodemailer');
// create reusable transporter object using the default SMTP transport
// var transporter = nodemailer.createTransport("SMTP", {
//   service: "Gmail",
//   auth: {
//     XOAuth2: {
//       user: "dynamicpricingcloud@gmail.com", // Your gmail address.
//                                             // Not @developer.gserviceaccount.com
//       clientId: "80958301885-bng47a9lf4j5lhdu0mt63te9su7gledv.apps.googleusercontent.com",
//       clientSecret: "G17twp_CaZCL41c9oHWtCTJo",
//       refreshToken: "1/bkfgJpvrd8ZmfacZ-hbI1_sihj_PNOEJosq-DrHW0UZ90RDknAdJa_sgfheVM0XT"
//     }
//   }
// });

var transporter = nodemailer.createTransport('smtps://dynamicpricingcloud%40gmail.com:dynamicPricing2016@smtp.gmail.com');
//var fs = require('fs');
var TIME_PENALTY = 24; // Number of hours to stop user from retry biddingF
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

app.get('/',function(req,response){
    console.log(req.query);
});

//===============ROUTES===============
app.get('/signup', function (req, response) {
    /*
     * get the username  and password
     *
    */
    console.log(req.query.username);
    var user = {
        username: req.query.username,
        password: req.query.password,
        email: req.query.email,
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
    console.log(req.query);
    var user = {
        username: req.query.username,
        password: req.query.password
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
              response.sendStatus(406);
          }
    });

});


app.get('/profile', function(req,response){
    console.log(req.query);
    var username = req.query.username;
    connection.query({
        sql: 'SELECT b_name ,itemname , bid_price,time FROM history, business,item WHERE username= ? AND history.bid=business.b_id AND history.iid= item.itemid',
        values:[username],
    }, function(err, res,fields){
            if(err){
                console.log(err);
                response.sendStatus(500);
            }else if (res.length == 0) {
                response.sendStatus(404)

            }else {
		record = "";
		for (var i = 0 ; i <res.length; i++){
			record= record + res[i]['b_name'] + " "+res[i]['itemname'] +" "+res[i]['bid_price']+"$"+" " +res[i]['time']+"\n";
		}
                response.send(record);
            }
    });
});

app.get('/scan',function(req,response){
    console.log(req.query);
    var bid = 0;
    var itemid = req.query.barcode;
    // get  the bid by the business id
    connection.query({
        sql: 'SELECT b_id FROM business WHERE b_name= ?',
        values:[req.query.businessname],
    }, function(err, bid_res,fields){
        if(err){
            console.log(err);
            response.sendStatus(500);
        } else if (bid_res.length == 0){
            response.sendStatus(406);
        }else{
            // check whether the item is under dynamic pricing
            bid = parseInt(bid_res[0]["b_id"]);
            connection.query({
                sql: 'SELECT price FROM buy WHERE b_id= ? AND itemid =?',
                values:[bid,itemid]
            },function(err,buy_res,fields){
                if(err){
                    console.log(err);
                    response.sendStatus(500);
                } else if (buy_res.length == 0){
                    response.sendStatus(406);
                }else{
		    response.sendStatus(200);
		}
	    });
	}
    });
});


app.get('/bid',function(req,response){
    console.log(req.query);
    var bid = 0;
    var itemid = req.query.barcode;
    var username = req.query.username;
    // get  the bid by the business id
    connection.query({
        sql: 'SELECT b_id FROM business WHERE b_name= ?',
        values:[req.query.businessname],
    }, function(err, bid_res,fields){
        if(err){
            console.log(err);
            response.sendStatus(500);
        } else if (bid_res.length == 0){
            response.sendStatus(500);
        }else{
            // check whether the item is under dynamic pricing
            bid = parseInt(bid_res[0]["b_id"]);
            connection.query({
                sql: 'SELECT price FROM buy WHERE b_id= ? AND itemid =?',
                values:[bid,itemid]
            },function(err,buy_res,fields){
                if(err){
                    console.log(err);
                    response.sendStatus(500);
                } else if (buy_res.length == 0){
                    response.sendStatus(500);
                }else{
                    price = parseFloat(buy_res[0]["price"]);
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

                            //get the price from buy
                            connection.query({
                                sql: 'SELECT itemname,description  FROM item WHERE itemid = ?',
                                values:[itemid,bid],
                            }, function(err, desp_res,fields){
                                if(err){
                                    console.log(err);
                                    response.sendStatus(500);
                                }else if (desp_res.length== 0){
                                    response.sendStatus(500);
                                }else{
                                    desp_res[0].price = price;
                                    response.send(desp_res[0]);
                                }// endd else
                            });// end query  of descripton

                        }// end else
                    });// end  query of time

                }  // end else
            });// end query of buy
        }// end else
    });// end query of bid

});// end scan function

app.get('/transaction',function(req,response){
    console.log(req.query);
    var bid_price = parseFloat(req.query.bid_price);
    var itemid = req.query.barcode;
    var username = req.query.username;
    var bid = 0;
    var businessname = req.query.businessname;
    // get  the bid by the business id
    connection.query({
        sql: 'SELECT b_id FROM business WHERE b_name= ?',
        values:[businessname],
    }, function(err, bid_res,fields){
        if(err){
            console.log(err);
            response.sendStatus(500);
        } else if (bid_res.length == 0){
            response.sendStatus(500);
        }else{
            bid = bid_res[0]["b_id"];
            connection.query({
                sql: 'INSERT INTO history (username,bid,iid,bid_price,time) VALUES (?, ?, ?, ?,  NOW())',
                values:[username, bid, itemid, bid_price],
            }, function(err, insert_res,fields){
                if (err){
                    console.log(err);
                    response.sendStatus(500);
                // }else if (bid_price != 0){
                //      var code = qr.image('{from: dynamic pricing, ' + 'to:'+businessname +', barcode:'+ itemid +', bid_price:' + bid_price+'}', { type: 'svg' });
  		      //        response.type('svg');
  		      //        code.pipe(response);
                } else{
                    response.sendStatus(200);
                }// end else
            });  // end query of insert
        }// end else
    });// end query of find bid
});

app.get('/forgetPassword',function(req,response){
    username = req.query.username;
    email = req.query.email;
    password = "";

    connection.query({
        sql: 'SELECT password FROM user WHERE username=? AND email = ? ',
        values:[username, email],
    }, function(err, pass_res,fields){
        if (err){
            console.log(err);
            response.sendStatus(500);
        }else if (pass_res.length == 0){
            response.sendStatus(406);
        }else{
            password = pass_res[0]['password'];
            // setup e-mail data with unicode symbols
            var mailOptions = {
                from: '"dynamic pricing Inc" <dynamicpricingcloud@gmail.com>', // sender address
                to: email, // list of receivers
                subject: 'password recovery', // Subject line
                text: 'Dear customer:\n \n You have request a recovery of password.\n Your username:' + username +"\n Your password:"+password + '\n \n \n Thank you for using Bideal! \n dynamic pricing team', // plaintext body
            };

            // send mail with defined transport object
            transporter.sendMail(mailOptions, function(error, info){
                if(error){
                    console.log(error);
                    response.sendStatus(500);
                }else{
                    console.log('Message sent: ' + info.response);
                    response.sendStatus(200);
                }
            });




        }
    });




});


app.get('/resetPassword',function(req,response){
    username = req.query.username;
    oldpassword= req.query.oldpassword;
    newpassword= req.query.newpassword;
    connection.query({
        sql: 'SELECT * FROM user WHERE username=? AND password =?',
        values:[username,oldpassword],
    }, function(err, pass_res,fields){
        if (err){
            console.log(err);
            response.sendStatus(500);
        }else if (pass_res.length== 0 ){
            response.sendStatus(406);
        }else{
            connection.query({
                sql: 'UPDATE user SET password=?  WHERE username=?',
                values:[newpassword, username],
            }, function(err, pass_res,fields){
                if (err){
                    console.log(err);
                    response.sendStatus(500);
                }else{
                    response.sendStatus(202);
                }
            });

        }
    });
});
app.get('/amazon', function(req,res){


});







var listenPort =  process.env.PORT|| 8081;
var server = app.listen(listenPort);
// console.log("listening on " + port + "!");
