const http = require('http');
const app = require('./app');

let port = process.env.PORT;

if (port == null || port == "") {
  port = 3000;
}

const server = http.createServer(app);

server.listen(port, () => {
  console.log("Server started Successfully");
});
