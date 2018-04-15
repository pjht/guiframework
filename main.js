var socket=new WebSocket("ws://localhost:2345");
window.onbeforeunload = function(){
   socket.close();
}

function sendMessage(message) {
  socket.send(message);
}
