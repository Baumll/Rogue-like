extends Control


signal mun_selected(num)
signal char_selected(character)
signal move_pressed(move)

onready var recktList = []
onready var buttonList = []
var characterList = []
var activeCharacter = null

var mouse_off = null
var switchMove = -1

onready var container = $CenterContainer/HBoxContainer
var preButton = preload("res://scenes/UI/Inventory/ButtonWithImage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in recktList:
		x.texture = null
		
func _process(delta):
	if switchMove != -1:
		buttonList[switchMove].change_pos(clamp(get_local_mouse_position().x-mouse_off.x,-20,864),buttonList[switchMove].rect_position.y) 
		for i in range(0,buttonList.size()):
			if i != switchMove:
				if(get_local_mouse_position().x > buttonList[i].rect_position.x and get_local_mouse_position().x < buttonList[i].rect_position.x+(864/buttonList.size())):
					container.move_child(buttonList[switchMove],buttonList[i].get_index () )
					"""
					var tmpSwitch = buttonList[switchMove]
					buttonList[switchMove] = buttonList[i]
					buttonList[i] = buttonList[switchMove]
					tmpSwitch = get_fighters()[switchMove]
					get_fighters()[switchMove] = get_fighters()[i]
					get_fighters()[i] = tmpSwitch
					"""
					var tmpSwitch = get_node("/root/Main").get_fighters()[switchMove] 
					get_node("/root/Main").get_fighters()[switchMove] = get_node("/root/Main").get_fighters()[i]
					get_node("/root/Main").get_fighters()[i]  = tmpSwitch

func set_char_active(character):
	emit_signal("char_selected", character)
	activeCharacter = character

func reset():
	characterList = []
	for x in recktList:
		x.texture = null

func add_character(character):
	if characterList.size() < GlobalFunktions.team_size:
		activeCharacter = character
		characterList.append(character)
		emit_signal("char_selected",character)
		var newButton = preButton.instance()
		newButton.connect("buttonNum", self, "_on_button_down")
		newButton.connect("buttonPressedNum", self, "_on_button_pressed")
		newButton.set_image(character.icon)
		newButton.set_number(characterList.size()-1)
		buttonList.append(newButton)
		container.add_child(newButton)
		container.move_child(newButton,newButton.get_index()-1 )
		for i in buttonList:
			i.change_size(864/buttonList.size(), 216 )

func remove_character(character):
	for x in range(characterList.size()):
		if characterList[x] == character:
			characterList.remove(x)
			pass


func _on_button_down(num):
	emit_signal("mun_selected", num)
	if characterList.size() > num:
		emit_signal("char_selected", characterList[num])
		activeCharacter = characterList[num]
		mouse_off = Vector2(get_local_mouse_position()-buttonList[num].rect_position)
		switchMove = num


#Hier für das verschieben
func _on_button_pressed(num):
	buttonList[num].change_pos(864/buttonList.size()*buttonList[num].get_index(),0)
	switchMove = -1
		

func _on_char04_pressed():
	emit_signal("mun_selected", -1)


func _on_AttackButtons_attackUP(num):
	if activeCharacter != null:
		if activeCharacter.moves.size() > num:
			if activeCharacter.moves[num] != null:
				emit_signal("move_pressed",activeCharacter.moves[num])


func _on_AttackButtons_attackDown(num):
	if activeCharacter != null:
		if activeCharacter.moves.size() > num:
			if activeCharacter.moves[num] != null:
				emit_signal("move_pressed",activeCharacter.moves[num])
