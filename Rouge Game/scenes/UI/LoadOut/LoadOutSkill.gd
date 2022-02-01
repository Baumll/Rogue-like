extends HBoxContainer

signal levelUp(num)

onready var label = $Label
onready var button = $Button 
var num = -1

func _ready():
	set_level_up(false)

func set_text(text):
	label.text = text
	#label.update()

func set_level_up(state):
	button.visible = state


func _on_Button_button_up():
	emit_signal("levelUp",num)
