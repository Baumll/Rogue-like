extends HBoxContainer

signal level_up()

onready var label = $Label
onready var button = $Button 

func _ready():
	set_level_up(false)

func set_text(text):
	get_child(0).set_text(text)
	#label.update()

func set_level_up(state):
	button.visible = state


func _on_Button_button_up():
	emit_signal("level_up")
