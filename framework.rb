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
  def initialize(text)
    @text=text
  end

  def render()
    return @text
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
  @@buttonids={}
  @@idbuttons={}
  @@nextid=0
  attr_reader :block
  def initialize(name,&block)
    @name=name
    @@buttonids[self]=@@nextid
    @@idbuttons[@@nextid]=self
    @@nextid+=1
    @block=block
  end

  def render()
    return "<button onclick=\"sendMessage('b#{@@buttonids[self]}')\">#{@name}</button>"
  end

  def self.idbuttons()
    return @@idbuttons
  end
end
