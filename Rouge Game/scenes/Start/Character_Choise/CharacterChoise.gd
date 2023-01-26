extends Control

signal mun_selected(num)
signal char_selected(character)
signal move_pressed(move)

onready var recktList = []
onready var buttonList = []
var characterList = []
var activeCharacter = null

#Size
var ysize = 100
var xsize = 864

var mouse_off = null
var switchMove = -1

onready var container = $HBox
var preButton = preload("res://scenes/UI/ui_under/ButtonWithImage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	ysize = self.rect_size.y
	xsize = self.rect_size.x
	for x in recktList:
		x.texture = null
		
func _process(_delta):
	if switchMove != -1:
		buttonList[switchMove].change_pos(clamp(get_local_mouse_position().x-mouse_off.x,-20,864),buttonList[switchMove].rect_position.y) 
		for i in range(0,buttonList.size()):
			if i != switchMove:
				if(get_local_mouse_position().x > buttonList[i].rect_position.x and get_local_mouse_position().x < buttonList[i].rect_position.x+(864/buttonList.size())):
					container.move_child(buttonList[switchMove],buttonList[i].get_index () )
					var tmpSwitch = GameData.heros[switchMove] 
					GameData.heros[switchMove] = GameData.heros[i]
					GameData.heros[i]  = tmpSwitch
	if container.get_child_count() != GameData.heros.size():
		reset()
		for hero in GameData.heros:
			add_character(hero)

func set_char_active(character):
	emit_signal("char_selected", character)
	activeCharacter = character

func reset():
	recktList = []
	buttonList = []
	characterList = []
	for x in container.get_children():
		x.queue_free()

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
		for i in range(buttonList.size()):
			buttonList[i].change_size(xsize/buttonList.size(), ysize)
			buttonList[i].change_pos(i * (xsize/buttonList.size()),rect_position.y)

func remove_character(character):
	for x in range(characterList.size()):
		if characterList[x] == character:
			characterList.remove(x)
			pass


func _on_button_down(num):
	emit_signal("mun_selected", num)
	if characterList.size() > num:
		GameData.active_character = characterList[num]
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
