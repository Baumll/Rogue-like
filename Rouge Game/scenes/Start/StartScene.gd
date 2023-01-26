extends Control

signal exit()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var character = GlobalFunktions.get_hero_list()[0]
	character = GlobalFunktions.load_character(character)
	GameData.heros.append(character)
	character.calculate_all_stats()
	GameData.active_character = character
	emit_signal("exit")
