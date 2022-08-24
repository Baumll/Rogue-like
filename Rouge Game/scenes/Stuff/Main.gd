extends Node



var doors = []

export(int) var maxCharacters = 4
var activeChracter = null

var inventory = [null,null,null,null,null,null,null,null,null]
var gold = 20
var roomList = []
var room = null

export(int) var rows = 3
export(int) var collums = 3

#Create Data to save:
var characterList = []


onready var door = $VBoxContainer/DoorScene
onready var start = $Start
onready var character_screen = $CharSelectScreen
onready var two_choise = $VBoxContainer/TwoChoise
onready var win_screen = $WinSzene
onready var lose_screen = $LoseSzene
onready var load_screen = preload("res://scenes/UI/LoadOut/LoadOut.tscn")



func roomListSetup():
	#Rist Path, Icon, Rarity
	roomList.append(["res://scenes/UI/Rooms/HealRoom.tscn","res://Assets/images/Icons/Rooms/green_14.PNG", 2])
	roomList.append(["res://scenes/UI/Rooms/mercenario.tscn","res://Assets/images/Icons/Rooms/yellow_40.png", 2])
	roomList.append(["res://scenes/UI/Rooms/Fighting/FightScene.tscn","res://Assets/images/Icons/Rooms/blue_12.png", 2])
	roomList.append(["res://scenes/UI/Rooms/merchantScene.tscn","res://Assets/images/Icons/Rooms/gray_07.PNG", 2])
	roomList.append(["res://scenes/UI/Rooms/ItemRoom.tscn","res://Assets/images/Icons/Rooms/TradingIcons_08.png", 2])

# Called when the node enters the scene tree for the first time.
func _ready():
	#Load Data
	GlobalFunktions.set_up_rng()
	GlobalFunktions.load_item_list()
	GlobalFunktions.load_enemy_list()
	GlobalFunktions.load_move_list()
	
	setup_start()
	roomListSetup()

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
	for i in range(2):
		num = GlobalFunktions.rng.randi_range(0,roomList.size()-1)
		doors.append(num)
	door.setup_doors(load(roomList[doors[0]][1]), load(roomList[doors[1]][1]))
	two_choise.visible = true
	save_game()

func disable_all():
	door.visible = false
	start.visible = false
	character_screen.visible = false
	two_choise.visible = false
	win_screen.visible = false
	lose_screen.visible = false

func load_characters_fight():
	var enemys = GlobalFunktions.pick_enemys(GlobalFunktions.rng.randi_range(2,4), GlobalFunktions.power_level)
	var friends = get_fighters()
	return [enemys, friends]
	
func _on_Start_start_pressed():
	setup_char_select()

func get_fighters():
	return characterList



func _on_DoorScene_door_enter(num):
	room = load(roomList[doors[num]][0])
	room = room.instance()
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
	#room.load_all_chracters(get_fighters())
	room.connect("exit", self,"_on_exit")

func _on_CharSelectScreen_Chosen(num):
	select_chracter(num)
	setup_doors()
	


#Old später unten einfügen?
func _on_FightScene_endFight(team, ep):
	if(team == 1):
		#xp veteilen:
		for i in get_fighters():
			i.give_exp(ep/get_fighters().size())
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
	if get_fighters().size() <= maxCharacters:
		var num = GlobalFunktions.rng.randi_range(0,3)
		select_chracter(num)
	setup_doors()



func select_chracter(preCharacter):
	#Erstellt den character
	var character = preCharacter


	get_fighters().append(character)
	activeChracter = get_fighters()[get_fighters().size()-1]
	#activeChracter.health = activeChracter.max_health
	
	activeChracter.calculate_all_stats()
	
	print(get_fighters())


func _on_HealRoom_full_team_heal():
	for i in get_fighters():
		i.health = i.max_health
	setup_doors()


func _on_exit():
	#checkt ob noch alle chars amleben sind
	if room != null:
		if room.name == "FightScene":
			for x in get_fighters():
				if x.health > 0:
					#win screen hier noch besser machen
					save_game()
					win_screen.visible
					room.queue_free()
					return
			lose_screen.visible
			room.queue_free()
			return
		room.queue_free()
		room = null
	setup_doors()

#Save Game
func save_game():
	#Check if folder ecists:
	var dir = Directory.new()
	if !dir.dir_exists(GlobalFunktions.save_dir):
		dir.make_dir_recursive(GlobalFunktions.save_dir)
	
	#Save Data:
	var save_game = File.new()
	var error = save_game.open(GlobalFunktions.save_file, File.WRITE)
	if error == OK:
		
		#Speicher bis jtzt nur die Charactere
		var saveChars = []
		var data = {"Characters" : saveChars,
		"Version" : "PreAlpha"}
		for i in range(characterList.size()):
			saveChars.append(characterList[i].character_to_lib(i))
		
		save_game.store_var(data)
		save_game.close()
		print("Data saved")
	else:
		print("Can't open file")

func load_game():
	var save_game = File.new()
	if save_game.file_exists(GlobalFunktions.save_file):
		var error = save_game.open(GlobalFunktions.save_file, File.READ)
		if error == OK:
			#Hier laden
			var player_data = save_game.get_var()
			var characterList = [null,null,null,null]
			for i in player_data["Characters"]:
				characterList[i["Position"]] = ChrFunc.new_character(i)
			save_game.close()
			print("Data loaded")
			return player_data
		else:
			print("Can't open file")
	else:
		print("No Save File")



func _on_Start_load_pressed():
	var data = load_game()
	for i in data["Characters"]:
		select_chracter(i)
	setup_doors()
	
