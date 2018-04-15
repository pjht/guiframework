require "socket"

def sfile(file,headers,type,client,url)
  total=file.length
  range=headers["Range"]
  positions=range.split("=")[1].split("-")
  start=positions[0].to_i(10)
  m_end=positions[1] ? positions[1].to_i(10) : total - 1;
  chunksize=(m_end-start)+1
  chunk=file[start, m_end+1]
  if type=="mp4"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"video/mp4"}
  elsif type=="webm"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"video/webm"}
  elsif type=="mpeg"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/mpeg"}
  elsif type=="ogg"
    r_headers={"Content-Range"=>"bytes #{start}-#{m_end}/#{total}","Accept-Ranges"=>"bytes","Content-Length"=>chunksize,"Content-Type"=>"audio/ogg"}
  end
  header=""
  r_headers.each do |key,value|
    header+="#{key}: #{value}"
  end
  client.puts "HTTP/1.1 206 Partial Content"
  client.print "#{header}"
  client.print "\n\n"
  client.print "#{chunk}"
  client.close
end

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
          elsif wname.include? ".mp4"
            sfile(File.open(wname, "rb") {|io| io.read},headers,"mp4",client,url)
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
