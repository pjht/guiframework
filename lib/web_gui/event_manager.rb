class EventManager
  include Dry::Events::Publisher[:event_manager]
  register_event("button.pushed")
  register_event("menu.updated")
  register_event("textfield.updated")
  register_event("checkbox.updated")
  register_event("radiobutton.updated")
end
