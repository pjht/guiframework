require_relative "framework"
$op=nil
$num1=nil
$num2=nil
app=App.new("My application") {
  add_element(Text.new("hi"))
  add_element(Button.new(:wind))
  add_element(Image.new("peter"))
  add_element(Video.new("test"))
  add_element(Text.new("Calculator:"))
  opthash={:add=>"Add",:sub=>"Subtract",:mult=>"Multiply",:div=>"Divide"}
  add_element(TextField.new { |val|
      $num1=val.to_f
    })
  add_element(Menu.new(opthash) { |val|
    $op=val
  })
  add_element(TextField.new { |val|
      $num2=val.to_f
  })
  res=nil
  add_element(ActionButton.new("Calculate") {
    case $op
    when :add
      result=$num1+$num2
    when :sub
      result=$num1-$num2
    when :mult
      result=$num1*$num2
    when :div
      result=$num1.to_f/$num2
    end
    res.settext("Result:#{result}")
  })
  res=add_element(Text.new("Result:"))
}
app.add_window(:wind,"A window") {
  add_element(Text.new("hello"))
  add_element(Button.new(:main))
}
app.run
