extends Node

var rng = RandomNumberGenerator.new()

signal selectCharacter(chracter)


var doors = []

export(int) var maxCharacters = 4
var characterList = []
var activeChracter = null

var inventory = [null,null,null,null,null,null,null,null,null]
var gold = 20
var roomList = []
var room = null

export(int) var rows = 3
export(int) var collums = 3

onready var door = $VBoxContainer/DoorScene
onready var start = $Start
onready var character_screen = $CharSelectScreen
onready var ui_under = $VBoxContainer/Ui_Under
onready var two_choise = $VBoxContainer/TwoChoise
onready var win_screen = $WinSzene
onready var lose_screen = $LoseSzene
onready var load_screen = preload("res://scenes/UI/LoadOut/LoadOut.tscn")

func roomList():
	#Rist Path, Icon, Rarity
	roomList.append(["res://scenes/UI/Rooms/HealRoom.tscn","res://Assets/images/Icons/Rooms/green_14.PNG", 2])
	roomList.append(["res://scenes/UI/Rooms/mercenario.tscn","res://Assets/images/Icons/Rooms/yellow_40.png", 2])
	roomList.append(["res://scenes/UI/Fighting/FightScene.tscn","res://Assets/images/Icons/Rooms/blue_12.png", 2])
	roomList.append(["res://scenes/UI/Rooms/merchantScene.tscn","res://Assets/images/Icons/Rooms/gray_07.PNG", 2])
	roomList.append(["res://scenes/UI/Rooms/ItemRoom.tscn","res://Assets/images/Icons/Rooms/TradingIcons_08.png", 2])

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup_start()
	roomList()

func _process(delta):
	if(Input.is_action_just_pressed("ui_down")):
		room = load(roomList[2][0]).instance()
		add_child(room)
		room.connect("exit", self,"_on_exit")
		room.visible = true

func setup_start():
	disable_all()
	start.visible = true

func setup_char_select():
	disable_all()
	character_screen.visible = true

func setup_doors():
	if(room != null):
		room.queue_free()
		room = null
	disable_all()
	door.visible = true
	var num = 0
	doors = []
	rng.randomize()
	for i in range(2):
		num = rng.randi_range(0,roomList.size()-1)
		doors.append(num)
	door.setup_doors(load(roomList[doors[0]][1]), load(roomList[doors[1]][1]))
	two_choise.visible = true

func enter_door():
	var num = 0
	rng.randomize()
	num = rng.randi_range(0,3)
	#hier raum laden


func disable_all():
	door.visible = false
	start.visible = false
	character_screen.visible = false
	two_choise.visible = false
	win_screen.visible = false
	lose_screen.visible = false

func load_enemy() -> Resource:
	#var preChar = load("res://Units/CharacterSzene.tscn")
	#var character = preChar.instance()
	var i = rng.randi_range(-1.0,1.0)
	var scene = load("res://ScribtAble/ClassChracter.gd")
	scene = scene.new()
	
	var character
	if i > 0:
		scene.loadStats("res://Units/enemys/UnitSkelett.tres")
	else:
		scene.loadStats("res://Units/enemys/UnitZombie.tres")
	return scene

func load_characters_fight():
	var enemys = []
	for x in range(0,rng.randi_range(1,4)):
		enemys.append(load_enemy())
	var friends = characterList
	return [enemys, friends]
	
func _on_Start_start_pressed():
	setup_char_select()

func get_fighters():
	return characterList



func _on_DoorScene_door_enter(num):
	room = load(roomList[doors[num]][0]).instance()
	add_child(room)
	room.connect("exit", self,"_on_exit")
	room.visible = true


func _on_TwoChoise_choise_made(num):
	if(door.visible == true):
		setup_load_out()

func setup_load_out():
	disable_all()
	room = load_screen.instance()
	add_child(room)
	#room.load_all_chracters(characterList)
	room.connect("exit", self,"_on_exit")

func _on_CharSelectScreen_Chosen(num):
	load_chracter(num)
	setup_doors()
	


#Old später unten einfügen?
func _on_FightScene_endFight(team, ep):
	if(team == 1):
		#xp veteilen:
		for i in characterList:
			i.give_exp(ep/characterList.size())
		#inventory.create_item()


func _on_WinSzene_winSzene():
	setup_doors()


func _on_LoseSzene_loseSzene():
	characterList = []
	activeChracter = null
	setup_start()


func _on_inventory_inventoryButton():
	if door.visible == false:
		setup_doors()


func _on_mercenario_mercenario():
	if characterList.size() <= maxCharacters:
		rng.randomize()
		var num = rng.randi_range(0,3)
		load_chracter(num)
	setup_doors()


func load_chracter(num):
		var preChar = load("res://ScribtAble/ClassChracter.gd")
		var character = preChar.new()
		
		match num:
			0: 
				character.loadStats("res://Units/Characters/charMage.tres")
			1: 
				character.loadStats("res://Units/Characters/charWarrier.tres")
			2: 
				character.loadStats("res://Units/Characters/charRanger.tres")
			3: 
				character.loadStats("res://Units/Characters/charNecro.tres")
		
		characterList.append(character)
		activeChracter = characterList[characterList.size()-1]
		activeChracter.health = activeChracter.maxHealth
		#character_reset_stats(activeChracter)
		activeChracter.reset_stats()
		#inventory.load_equip(activeChracter)
		print(characterList)





func _on_HealRoom_full_team_heal():
	for i in characterList:
		i.health = i.maxHealth
	setup_doors()

		

func _on_exit():
	#checkt ob noch alle chars amleben sind
	if room != null:
		if room.name == "FightScene":
			for x in characterList:
				if x.health > 0:
					#win screen hier noch besser machen
					win_screen.visible
					room.queue_free()
					return
			lose_screen.visible
			room.queue_free()
			return
		room.queue_free()
		room = null
	setup_doors()
