require_relative "app"
require_relative "window"
require_relative "element"
require_relative "serv"
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
    return "<img src=\"#{@name}\"></img>"
  end
end
