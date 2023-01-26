extends VBoxContainer

signal exit()

var character_list = null

func start(characters):
	character_list = characters

func _on_ButtonLeft_button_up():
	for hero in GameData.heros:
		hero.holy += 10
	emit_signal("exit")


func _on_ButtonRight_button_up():
	for hero in GameData.heros:
		hero.holy -= 2
	emit_signal("exit")
