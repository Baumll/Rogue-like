extends VBoxContainer

signal exit_room()

var character_list = null

func start(characters):
	character_list = characters

func _on_ButtonLeft_button_up():
	emit_signal("exit_room")


func _on_ButtonRight_button_up():
	emit_signal("exit_room")
