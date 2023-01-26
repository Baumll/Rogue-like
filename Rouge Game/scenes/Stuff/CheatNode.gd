extends Node


var secret_string = ""
export(int, LAYERS_2D_PHYSICS) var targets
onready var main = get_tree().get_root().get_node("Main")

func _ready():
	print('Targets: '+ str(targets))
	var rgba = [0,0,0,0]
	rgba[0] = targets & 0xff;
	rgba[1] = (targets >> 8) & 0xff;
	rgba[2] = (targets >> 16) & 0xff;
	rgba[3] = (targets >> 24) & 0xff;
	for i in rgba:
		print(i)


func _input(event: InputEvent):
	if (event is InputEventKey and event.is_pressed()):
		#print(OS.get_scancode_string(event.scancode))
		secret_string += OS.get_scancode_string(event.scancode).to_lower()
		if "levelup" in secret_string:
			print("LEVEL UP!")
			secret_string = ""
			GameData.active_character.level_up()
		if "money" in secret_string:
			print("MONEY!")
			secret_string = ""
			GameData.gold += 100
