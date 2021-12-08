extends Control


signal char_selected(num)


onready var recktList = [$CenterContainer/HBoxContainer/char03/TextureRect3, $CenterContainer/HBoxContainer/char02/TextureRect2, $CenterContainer/HBoxContainer/char01/TextureRect]
onready var buttonList = [$CenterContainer/HBoxContainer/char03, $CenterContainer/HBoxContainer/char02, $CenterContainer/HBoxContainer/char01]
onready var extraButton = $CenterContainer/HBoxContainer/char04
var characterList = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in recktList:
		x.texture = null


func reset():
	characterList = []
	for x in recktList:
		x.texture = null

func add_character(character):
	
	if characterList.size() < 3:
		characterList.append(character)
		recktList[characterList.size()-1].texture = character.icon

func remove_character(character):
	for x in range(characterList.size()):
		if characterList[x] == character:
			characterList.remove(x)
			pass


func _on_char03_pressed():
	emit_signal("char_selected", 0)


func _on_char02_pressed():
	emit_signal("char_selected", 1)


func _on_char01_pressed():
	emit_signal("char_selected", 2)


func _on_char04_pressed():
	emit_signal("char_selected", -1)
