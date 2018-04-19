require "bundler/setup"
Bundler.setup
require "web_gui"
$op=nil
$num1=nil
$num2=nil
app=WebGui::App.new("Calculator") {
  opthash={:add=>"Add",:sub=>"Subtract",:mult=>"Multiply",:div=>"Divide"}
  add_element(WebGui::TextField.new {|val| $num1=val.to_f})
  add_element(WebGui::Menu.new(opthash) {|val| $op=val})
  add_element(WebGui::TextField.new {|val| $num2=val.to_f})
  res=nil
  add_element(WebGui::ActionButton.new("Calculate") {
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
  res=add_element(WebGui::Text.new("Result:"))
}
app.run
