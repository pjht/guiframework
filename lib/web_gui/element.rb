$id=0
$idtoel={}
def get_id()
  id=$id
  $id+=1
  return id
end
class WebGui::Element < Dry::Struct
  constructor_type :strict_with_defaults
  attribute :id, Types::Coercible::Int.default { get_id() }
  def initialize(opthash=nil)
    if opthash
      super(opthash)
      @block=nil
    end
    $idtoel[id]=self
  end
  def render()
    return ""
  end
  def self.css()
    return @ccs
  end
end
