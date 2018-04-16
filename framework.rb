require_relative "app"
require_relative "window"
require_relative "element"
require_relative "serv"
require_relative "wsserv"
class Object
  def descendants
    ObjectSpace.each_object(::Class).select {|klass| klass < self }
  end
end

class Text < Element
  attr_reader :text
  @@ttoid={}
  @@idtot={}
  @@nextid=1
  def initialize(text)
    @text=text
    @@ttoid[self]=@@nextid
    @@idtot[@nextid]=self
    @@nextid+=1
  end

  def render()
    return "<p id=#{@@ttoid[self]}>#{@text}</p>"
  end

  def settext(text)
    $app.update("paragraph",@@ttoid[self],text)
  end
end

class Link < Element
  attr_reader :page, :text
  def initialize(page,text=nil)
    @page=page
    if text
      @text=text
    else
      @text=page.to_s
    end
  end

  def render()
    return "<a href=\"#{@page}\">#{@text}</a>"
  end
end


class Button < Link
  @css="a.button{-webkit-appearance: button;-moz-appearance: button;appearance: button;text-decoration: none;color: initial;padding: 0px 10px;}"

  def render()
    return "<a href=\"#{@page}\" class=\"button\">#{@text}</a>"
  end
end

class Image < Element
  def initialize(name)
    @name=name
  end

  def render()
    return "<img src=\"#{@name}.jpg\"></img>"
  end
end

class Video < Element
  def initialize(name)
    @name=name
  end

  def render()
    return "<video controls width=320 height=300><source src=\"#{@name}.webm\" type=\"video/webm\"><source src=\"#{@name}.mp4\" type=\"video/mp4\"></video>"
  end
end

class ActionButton < Element
  @@buttontoid={}
  @@idtobutton={}
  @@nextid=0
  attr_reader :block
  def initialize(name,&block)
    @name=name
    @@buttontoid[self]=@@nextid
    @@idtobutton[@@nextid]=self
    @@nextid+=1
    @block=block
  end

  def render()
    return "<button id=#{@@buttontoid[self]}>#{@name}</button>"
  end

  def self.idtobutton()
    return @@idtobutton
  end
end


class Menu < Element
  @@menutoid={}
  @@idtomenu={}
  @@nextid=0
  attr_reader :block
  def initialize(opts,&block)
    @opts=opts
    @@menutoid[self]=@@nextid
    @@idtomenu[@@nextid]=self
    @@nextid+=1
    @block=block
  end

  def render()
    html="<select id=#{@@menutoid[self]}>"
    @opts.each do |val,text|
      html+="<option value=\"#{val.to_s}\">#{text}</option>"
    end
    html+="</select>"
    return html
  end

  def self.idtomenu()
    return @@idtomenu
  end
end


class TextField < Element
  @@tftoid={}
  @@idtotf={}
  @@nextid=0
  attr_reader :block
  def initialize(&block)
    @@tftoid[self]=@@nextid
    @@idtotf[@@nextid]=self
    @@nextid+=1
    @block=block
  end

  def render()
    html="<input id=#{@@tftoid[self]}>"
  end

  def self.idtotf()
    return @@idtotf
  end
end

class RadioButton < Element
  @@idtorb={}
  @@rbtoid={}
  @@nextid=0
  attr_reader :block
  def initialize(buttons,&block)
    @@rbtoid[self]=@@nextid
    @@idtorb[@@nextid]=self
    @@nextid+=1
    @block=block
    @buttons=buttons
  end

  def render()
    html=""
    @buttons.each do |value,text|
      html+="<input type=\"radio\" id=#{@@rbtoid[self]} name=\"#{@@rbtoid[self]}\" value=\"#{value.to_s}\">#{text}<br>"
    end
    return html
  end

  def self.idtorb()
    return @@idtorb
  end
end
