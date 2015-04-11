var http = require('http'),
    httpProxy = require('http-proxy');

var proxy = httpProxy.createProxyServer({});

var server = http.createServer(function(req, res) {
  proxy.web(req, res, { target: 'http://127.0.0.1:4567' });
});

proxy.on('error', function (err, req, res) {
  res.writeHead(500, {
    'Content-Type': 'text/plain'
  });

  res.end("Something went wrong.\n");
});

console.log("listening on port 4566")
server.listen(4566);
