extends Node

signal cheat(cheat)

var secret_string = ""

onready var main = get_tree().get_root().get_node("Main")

func _input(event: InputEvent):
	if (event is InputEventKey and event.is_pressed()):
		#print(OS.get_scancode_string(event.scancode))
		secret_string += OS.get_scancode_string(event.scancode).to_lower()
		
		if "levelup" in secret_string:
			print("LEVEL UP!")
			secret_string = ""
			for i in main.characterList:
				i.level_up()
