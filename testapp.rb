require_relative "framework"
$op=nil
$num1=nil
$num2=nil
app=App.new("My application") {
  add_element(Text.new("hi"))
  add_element(Button.new(:wind,"Window"))
  add_element(Button.new(:calc,"Calculator"))
  add_element(Image.new("peter"))
  add_element(Video.new("test"))
  valradio=nil
  valcheck=nil
  add_element(RadioButton.new({:hi=>"Hi",:hello=>"Hello"}){|sel|
    valradio.settext("Value for radio buttons:#{sel}")
  })
  add_element(CheckBox.new({:hi=>"Hi",:hello=>"Hello"}){|sel|
    sel=sel.join(",")
    valcheck.settext("Value for checkboxes:#{sel}")
  })
  valradio=add_element(Text.new("Value for radio buttons:"))
  valcheck=add_element(Text.new("Value for checkboxes:"))
}
app.add_window(:wind,"A window") {
  add_element(Text.new("hello"))
  add_element(Button.new(:main,"Home"))

}
app.add_window(:calc,"Calculator") {
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
  add_element(Button.new(:main,"Home"))
}
app.run
