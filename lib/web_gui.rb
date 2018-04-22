module WebGui; end
require 'dry-struct'

module Types
  include Dry::Types.module
  Block=self.Instance(Proc)
end
require_relative "web_gui/app"
require_relative "web_gui/window"
require_relative "web_gui/element"
require_relative "web_gui/serv"
require_relative "web_gui/wsserv"
class Object
  def descendants
    ObjectSpace.each_object(::Class).select {|klass| klass < self }
  end
end
module WebGui
  class Text < Element
    attribute :text, Types::Coercible::String

    def render()
      return "<p id=#{id}>#{text}</p>"
    end

    def settext(text)
      $app.update("paragraph",id,text)
    end
  end

  class Link < Element
    attribute :page, Types::Symbol
    attribute :text, Types::Coercible::String.optional
    def render()
      if text
        return "<a href=\"#{page}\">#{text}</a>"
      else
        return "<a href=\"#{page}\">#{page.to_s}</a>"
      end
    end
  end


  class Button < Link
    @css="a.button{-webkit-appearance: button;-moz-appearance: button;appearance: button;text-decoration: none;color: initial;padding: 0px 10px;}"
    def render()
      return "<a href=\"#{page}\" class=\"button\">#{text}</a>"
    end

    def self.css()
      return @css
    end
  end

  class Image < Element
    attribute :name, Types::Coercible::String
    def render()
      return "<img src=\"#{name}.jpg\"></img>"
    end
  end

  class Video < Element
    attribute :name, Types::Coercible::String

    def render()
      return "<video controls width=320 height=300><source src=\"#{name}.webm\" type=\"video/webm\"><source src=\"#{name}.mp4\" type=\"video/mp4\"></video>"
    end
  end

  class ActionButton < Element
    attribute :text, Types::Coercible::String
    def initialize(opthash, &block)
      super(opthash)
      @block=block
    end

    def render()
      return "<button id=#{id}>#{text}</button>"
    end
  end


  class Menu < Element
    attribute :opts, Types::Hash
    def initialize(opthash, &block)
      super(opthash)
      @block=block
    end

    def render()
      html="<select id=#{id}>"
      opts.each do |val,text|
        html+="<option value=\"#{val.to_s}\">#{text}</option>"
      end
      html+="</select>"
      return html
    end
  end


  class TextField < Element
    def initialize(opthash, &block)
      super(opthash)
      @block=block
    end

    def render()
      html="<input id=#{id}>"
    end
  end

  class RadioButton < Element
    attribute :buttons, Types::Coercible::Hash
    def initialize(opthash, &block)
      super(opthash)
      @block=block
    end

    def render()
      html=""
      buttons.each do |value,text|
        html+="<input type=\"radio\" id=#{id} name=\"#{id}\" value=\"#{value.to_s}\">#{text}<br>"
      end
      return html
    end
  end


  class CheckBox < Element
    attribute :boxes, Types::Coercible::Hash
    def initialize(opthash, &block)
      super(opthash)
      @block=block
    end

    def render()
      html=""
      boxes.each do |value,text|
        html+="<input type=\"checkbox\" id=#{id} name=\"#{id}\" value=\"#{value.to_s}\">#{text}<br>"
      end
      return html
    end
  end
end
