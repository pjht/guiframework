require "bundler/setup"
Bundler.setup
require "web_gui"
$op=nil
$num1=nil
$num2=nil
app=WebGui::App.new("My application") {
  add_element(WebGui::Text.new(text: "hi"))
  add_element(WebGui::Button.new(page: :wind, text:"Window"))
  add_element(WebGui::Button.new(page: :calc, text:"Calculator"))
  add_element(WebGui::Image.new(name: "peter"))
  add_element(WebGui::Video.new(name: "test"))
  valradio=nil
  valcheck=nil
  add_element(WebGui::RadioButton.new(buttons: {:hi=>"Hi",:hello=>"Hello"}){|sel|
    valradio.settext("Value for radio buttons:#{sel}")
  })
  add_element(WebGui::CheckBox.new(boxes: {:hi=>"Hi",:hello=>"Hello"}){|sel|
    sel=sel.join(",")
    valcheck.settext("Value for checkboxes:#{sel}")
  })
  valradio=add_element(WebGui::Text.new(text: "Value for radio buttons:"))
  valcheck=add_element(WebGui::Text.new(text: "Value for checkboxes:"))
}
app.add_window(:wind,"A window") {
  add_element(WebGui::Text.new(text: "hello"))
  add_element(WebGui::Button.new(page: :main,text: "Home"))

}
app.add_window(:calc,"Calculator") {
  add_element(WebGui::Text.new(text: "Calculator:"))
  opthash={:add=>"Add",:sub=>"Subtract",:mult=>"Multiply",:div=>"Divide"}
  add_element(WebGui::TextField.new {|val| $num1=val.to_f})
  add_element(WebGui::Menu.new(opts: opthash) {|val| $op=val})
  add_element(WebGui::TextField.new {|val| $num2=val.to_f})
  res=nil
  add_element(WebGui::ActionButton.new(text: "Calculate") {
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
  res=add_element(WebGui::Text.new(text: "Result:"))
  add_element(WebGui::Button.new(page: :main,text: "Home"))
}
app.run
