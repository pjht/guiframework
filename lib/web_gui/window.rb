class WebGui::Window < Dry::Struct
  attribute :title, Types::Coercible::String.default("")
  attribute :name, Types::Coercible::String
  def initialize(opthash)
    super(opthash)
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
