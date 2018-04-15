require_relative "framework"
app=App.new("My application") {
  add_element(Text.new("hi"))
  add_element(Button.new(:wind))
  add_element(Image.new("peter"))
  add_element(Video.new("test"))
  add_element(ActionButton.new("Button") {
    puts "Hi!"
  })
}
app.add_window(:wind,"A window") {
  add_element(Text.new("hello"))
  add_element(Button.new(:main))
}
app.run
