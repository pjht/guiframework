var socket=new WebSocket("ws://localhost:2345");
window.onbeforeunload = function(){
   socket.close();
}

function sendMessage(message) {
  console.log("Sending "+message)
  socket.send(message);
}

socket.onmessage = function (event) {
  message=event.data;
  var temp=message.split("=");
  var part1=temp[0];
  var val=temp[1];
  var type=part1.match(/[a-zA-Z]+/);
  type=type[0];
  var id=part1.match(/\d+/);
  id=id[0];
  switch(type) {
    case "paragraph":
        $("p[id="+id+"]").text(val);
        break;
  }
}

$(document).ready(function(){
  $("button").click(function(){
    var id=$(this).attr("id");
    sendMessage("button"+id);
  });
  
  $("select").each(function(){
    var id=$(this).attr("id");
    var val=$(this).val();
    sendMessage("menu"+id+"="+val);
  });

  $("select").change(function(){
    var id=$(this).attr("id");
    var val=$(this).val();
    sendMessage("menu"+id+"="+val);
  });

  $("input").change(function(){
    var id=$(this).attr("id");
    var val=$(this).val();
    var type=$(this).attr("type");
    if (typeof type=="undefined") {
      sendMessage("textfield"+id+"="+val);
    }
    if (type=="radio") {
      sendMessage("radiobutton"+id+"="+val)
    }
    if (type=="checkbox") {
      val="";
      $("input[id="+id+"][type=\"checkbox\"]").each(function () {
        if (this.checked) {
          val+=$(this).val();
          val+="&";
        }
      });
      val=val.slice(0,-1);
      console.log(val);
      sendMessage("checkbox"+id+"="+val)
    }
  });
});
