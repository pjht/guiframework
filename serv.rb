require "socket"
def server(app)
  Thread::abort_on_exception=true
  server = TCPServer.new 2000
  $debug = true
  igfiles=["favicon.ico"]
  loop do
      Thread.start(server.accept) do |client|
      begin
        lines=[]
        line=client.gets
        while line != "\r\n"
          if line==nil
            lines=[""]
            runreq=false
            break
          end
          lines<<line
          line=client.gets
        end
        i=0
        lines.each do |value|
          lines[i]=value.chomp
          i=i+1
        end
        temp=lines.shift
        method=temp.split(" ")[0]
        url=temp.split(" ")[1]
        headers={}
        lines.each do |value|
          temp=value.split(": ")
          headers[temp[0]]=temp[1]
        end
        wname=url.gsub("/","")
        if igfiles.include? wname
          client.puts "HTTP/1.1 404 Not Found"
          client.puts "Content-Type:text/html"
          client.puts
          client.print ""
        else
          if wname.include? ".jpg"
            img=File.read(wname)
            client.puts "HTTP/1.1 200 OK"
            client.puts "Content-Type:image/jpeg"
            client.puts
            client.print img
          else
            wname="main" if wname==""
            wname=wname.to_sym
            doc=app.render_document(wname)
            client.puts "HTTP/1.1 200 OK"
            client.puts "Content-Type:text/html"
            client.puts
            client.print doc
          end
        end
        client.close
      rescue Exception=>e
        client.puts "HTTP/1.1 500 Internal Server Error"
        client.puts "Content-Type:text/plain"
        client.puts
        client.puts "Server error: #{e}"
        client.print e.backtrace.join("\n")
        client.close
      end
    end
  end
end
