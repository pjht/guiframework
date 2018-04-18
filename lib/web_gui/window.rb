class WebGui::Window
  attr_reader :name,:title,:elements
  attr_writer :title
  def initialize(name,title="")
    @name=name
    @title=title
    @elements=[]
  end

  def add_element(element)
    raise ArgumentError, "The element must be of type Element." unless element.is_a? WebGui::Element
    @elements.push element
    return element
  end

  def render()
    html=""
    @elements.each do |el|
      html+="<p>#{el.render()}</p>"
    end
    return html
  end

  def render_css()
    css=""
    WebGui::Element.descendants.each do |el|
      elcss=el.css
      if elcss!=nil
        css+=elcss
      end
    end
    return css
  end
end
