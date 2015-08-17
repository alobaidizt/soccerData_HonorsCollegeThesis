//Lets require/import the HTTP module
var http = require('http');

//Lets define a port we want to listen to
const PORT=8080; 

//Create a server
var server = http.createServer(function(req, res) {
  var done = finalhandler(req, res);
  serve(req, res, done);
});

//Lets start our server
server.listen(PORT);
console.log("Server running at http://127.0.0.1:8080/");
