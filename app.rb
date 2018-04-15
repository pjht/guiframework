$forcenochrome=false
class App
  attr_reader :windows
  def initialize(title,&block)
    if ARGV.length>0
      if ARGV[0]=="--forcenochrome"
        $forcenochrome=true
      end
    end
    @windows={}
    @windows[:main]=Window.new(:main,title)
    @windows[:main].instance_eval(&block)
  end

  def render_document(wname)
    window=windows[wname]
    html=window.render
    css=window.render_css
    doc=<<-ENDDOC
<!DOCTYPE html>
<html>
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src=\"main.js\"></script>
    <style>
      #{css}
    </style>
    <title>#{window.title}</title>
  </head>
  <body>
    #{html}
  </body>
</html>
    ENDDOC
    return doc
  end

  def add_window(wname,title,&block)
    @windows[wname]=Window.new(wname,title)
    @windows[wname].instance_eval(&block)
  end
  def run()
    servthread=Thread.new do
      server(self)
    end
    if File.exists? "/Applications/Google\ Chrome.app" and !$forcenochrome
      startwsserv()
      `"/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome" --app="http://localhost:2000"`
    else
      puts "Chrome is not on your system."
      puts "Please install Chrome to use this framework properly."
      puts "If Chrome is installed, please make sure it is called Google Chrome.app and is in the root Applications folder."
      puts "The app will open in your default browser as a regular webpage instead."
      sleep(5)
      `open http://localhost:2000`
      startwsserv()
      servthread.join
    end
  end

  def startwsserv()
    serv=WebSocketServer.new
    Thread.new(self,serv) do |parent,server|
      server.accept
      while true
        message=server.recv
        if message==false
          server.accept
          next
        end
        parent.handlemessage(message)
      end
    end
  end

  def handlemessage(message)
    puts "Got message #{message}"
    part1,val=message.split("=")
    part1=part1.split("")
    type=part1.shift
    part1=part1.join("")
    id=part1.to_i
    if val
      puts "Got message of type #{type} and id #{id} with value #{val}"
    else
      puts "Got message of type #{type} and id #{id}"
    end
    case type
    when "b"
      button=ActionButton.idtobutton[id]
      button.block.call
    when "m"
      menu=Menu.idtomenu[id]
      menu.block.call(val.to_sym)
    when "t"
      tf=TextField.idtotf[id]
      tf.block.call(val)
    end
  end
end
