var socket=new WebSocket("ws://localhost:2345");
window.onbeforeunload = function(){
   socket.close();
}

function sendMessage(message) {
  socket.send(message);
}
$(document).ready(function(){
  $("button").click(function(){
      var id=$(this).attr("id");
      sendMessage("button"+id);
  });

  $("select").change(function(){
      var id=$(this).attr("id");
      var val=$(this).val();
      sendMessage("menu"+id+"="+val);
  });

  $("select").each(function(){
      var id=$(this).attr("id");
      var val=$(this).val();
      sendMessage("menu"+id+"="+val);
  });

  $("input").change(function(){
      var id=$(this).attr("id");
      var val=$(this).val();
      sendMessage("textfield"+id+"="+val);
  });
});
