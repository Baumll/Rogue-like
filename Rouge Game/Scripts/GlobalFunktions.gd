extends Node

#Globale Variablen
var team_size = 4
var equip_size = 2
var inventory_rows = 3
var inventory_collums = 3

var save_dir = "user://save/"
var data_path = "res://csv/"
var save_file = save_dir + "rough.save" #Der Pfad wo gespeichert wird
var password = "BitteDenkeDirEinsAus"

var move_path = "res://Units/Attacks/"
var equip_path = "res://Units/Items/"
var status_path = "res://Units/States/"
var imagePath = ""
var icon_path = ""
var character_container = "res://ScribtAble/Container/Character.tscn"
var item_container = "res://ScribtAble/Container/Item.tscn"
var status_container = "res://ScribtAble/Container/Status.tscn"
var move_container = "res://ScribtAble/Container/Move.tscn"

var hero_list = null
var enemy_list = null
var item_list = null
var status_list = null
var move_list = null

var rng = null
var power_level = 1 #Wie stark die gegner und die Belohung sind

func _ready():
	rng = set_up_rng()

func set_up_rng(rngSeed = ""):
	var rng = RandomNumberGenerator.new()
	if rngSeed == "":
		rng.randomize()
	else:
		rng.seed = hash(rngSeed)
	return rng

func load_image(image):
	if image == null:
		return null
	print("Type of " + str(typeof(image)))
	return load(image)
	
func load_icon(icon):
	if icon == null:
		return null
	return load(icon)

func create_floaty_text(amount, position, color = Color('33040b') ):
	if(amount != null):
		var floaty_text_scene = load("res://scenes/UI/Fighting/Floating_Text.tscn")
		var floaty_text = floaty_text_scene.instance()
		
		floaty_text.position = position #Vector2(480/2, 270/2)
		floaty_text.velocity = Vector2(rand_range(-100, 100), -200)
		floaty_text.modulate = color#Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1.0)
		### White
		#floaty_text.modulate = Color(1.0, 1.0, 1.0, 1.0)
		#var amount = randi()%10 - 5
		floaty_text.text = amount
		
		if amount > 0:
			floaty_text.text = floaty_text.text
		add_child(floaty_text)

func get_inventory_size():
	return inventory_collums * inventory_rows

func add_item(item = null,slot = -1):
	if item:
		if slot >= 0 and slot < get_inventory_size():
			if GameData.inventory[slot] == null:
				 GameData.inventory[slot] = item
		for i in range(get_inventory_size()):
			if  GameData.inventory[i] == null:
				GameData.inventory[i] = item
				return

####Lade Zeugs
func read_json(path):
		#Read Data
	var file = File.new()
	file.open(path, file.READ)
	var data_cdb = parse_json(file.get_as_text())
	file.close()
	return data_cdb

func string_to_list(string, separator):
	var list = null
	if typeof(string) == TYPE_STRING:
		if string[0] == "[" and string[len(string)-1] == "]":
			#remove [ and ]
			string.erase(0,1)
			string.erase(len(string)-1,1)
			list = []
			var element = ""
			for i in string:
				if i == separator:
					if element.is_valid_integer():
						element = int(element)
					list.append(element)
					element = ""
				else:
					element = element + i
			list.append(element)
	return list

func read_csv(path):
	#Read Data Unbeding UINT-8!!!!
	var file = File.new()
	var err = file.open(path, file.READ)
	if err == OK:
		var csv = []
		while !file.eof_reached():
			var tmp_csv = file.get_csv_line(",")
			csv.append(tmp_csv)
		file.close()
	
		csv = csv.slice(0, len(csv)-2)
		
		var elemt_list = []
		for i in range(len(csv)-1):
			if len(csv[i]) == len(csv[0]):
				var item = {}
				for j in range(len(csv[i+1])):
					item[csv[0][j]] = csv[i+1][j]
					if item[csv[0][j]].is_valid_integer():
						item[csv[0][j]] = int(item[csv[0][j]])
					elif item[csv[0][j]] == "":
						item[csv[0][j]] = null
					elif item[csv[0][j]].is_valid_float():
						item[csv[0][j]] = float(item[csv[0][j]])
					elif item[csv[0][j]] == "true":
						item[csv[0][j]] = true
					elif item[csv[0][j]] == "false":
						item[csv[0][j]] = false
						#Wenn wir eine Liste haben in [ 1,2,3,4...]
					elif typeof(item[csv[0][j]]) == TYPE_STRING:
						if item[csv[0][j]].begins_with("[") and item[csv[0][j]].ends_with("]"):
							item[csv[0][j]] = string_to_list(item[csv[0][j]],",")
						
				elemt_list.append(item)
		return elemt_list
	else:
		print("Cant open " + str(path))
		file.close()
		return null


#Aus der Hero liste
func get_hero(name):
	for i in hero_list:
		if i["Name"] == name:
			var new_hero = load(character_container)
			new_hero = new_hero.instance()
			new_hero.load_stats(i)
			return new_hero
	return null

#Zum laden der Json datei mit den Charateren
func load_hero_list():
	#Hier werden die verfügbaren charactere geladen.
	var data_cdb = read_csv("res://csv/Hero_Data.csv")
	hero_list = data_cdb
	return data_cdb

func get_hero_list():
	if hero_list == null:
		load_hero_list()
	return hero_list

func add_hero(hero):
	if hero.typeof() == TYPE_DICTIONARY:
		hero = GlobalFunktions.load_character(hero)
	GameData.heros.append(hero)
	hero.calculate_all_stats()
	GameData.active_character = hero

###Enemy
func get_enemy(name):
	for i in enemy_list:
		if i["Name"] == name:
			var new_enemy = load(character_container)
			new_enemy = new_enemy.instance()
			new_enemy.load_status(i)
			return new_enemy
	return null

func load_enemy_list():
	#Hier werden die verfügbaren charactere geladen.
	var data_cdb = read_csv("res://csv/Enemy_Data.csv")
	enemy_list = data_cdb
	return data_cdb

func get_enemy_list():
	if enemy_list == null:
		load_enemy_list()
	return enemy_list

#Zum laden eines einzelnen Status
func get_status(name, turns = -2):
	if status_list == null:
		load_status_list()
	for i in status_list:
		if i["Name"] == name:
			var new_status = load(status_container)
			new_status = new_status.instance()
			new_status.load_status(i)
			if turns != -2:
				new_status.turns = turns
			return new_status
	return null

func load_status_list():
	var status_data = read_csv("res://csv/Status_Data.csv")
	status_list = status_data
	return status_data

func get_status_list():
	if status_list == null:
		load_status_list()
	return status_list


###Moves###
func get_move(name):
	if move_list == null:
		load_move_list()
	for i in move_list:
		if i["Name"] == name:
			var new_move = load(move_container)
			new_move = new_move.instance()
			new_move.load_move(i)
			return new_move
	return null

func load_move(move):
	if move:
		var new_move = load(move_container)
		new_move = new_move.instance()
		new_move.load_move(move)
		return new_move

func load_move_list():
	var move_data = read_csv("res://csv/Move_Data.csv")
	move_list = move_data
	return move_data

func get_move_list():
	if move_list == null:
		load_move_list()
	var new_list = []
	for i in move_list:
		new_list.append(load_move(i))
	return new_list


#Item---------------------------------
func load_item_list():
	#Hier werden alle items geladen 
	item_list = read_csv("res://csv/Item_Data.csv")
	print("Items loaded")
	return item_list

func get_item(name):
	if item_list == null:
		load_item_list()
	for i in item_list:
		if name == i["Name"]:
			var new_item = load(item_container)
			new_item = new_item.instance()
			new_item.load_stats(i)
			return new_item
	return null

func create_item(item = null):
	if item_list == null:
		load_item_list()
	if item == null:
		item = item_list[rng.randi_range(0, item_list.size()-1)]
		return get_item(item["Name"])
	else:
		return get_item(item)

func get_item_in_power_level():
	var power_level = get_power_range()
	var reduced_list = []
	for item in load_item_list():
		if item["Level"] >= power_level[0] and item["Level"] <= power_level[1]:
			reduced_list.append(item)
	if reduced_list.size() > 0:
		var new_item = load(item_container).instance()
		new_item.load_stats(reduced_list[rng.randi_range(0,reduced_list.size()-1)])
		return new_item
	return null

func create_emty_character(data = null):
	#data ist wenn ein vorgefertiter character
	var new_character = load(character_container).instance()
	if data != null:
		new_character.load_pre_stats(data)
	return new_character

func load_character(character):
	var new_character = load(character_container).instance()
	new_character.load_stats(character)
	return new_character

#Der Algorthymus findet zufällig gegner die ungeähr dem Powerlevel entsprechen
#Dafür sucht er sich einen zufälligen gegner aus der Liste die in Frage kommen aus.
#Passt die noch zu verwernden Power an und dann die Liste. und wiede holt so lange bis
#das Team voll ist
#Alle Bilder hier werden geladen.
func pick_enemys(power_level = -1, count = -1):
	if enemy_list == null:
		load_enemy_list()
	#-1 -> Zufällig viele
	if power_level == -1:
		power_level = GameData.power_level
	
	if count == -1:
		count = 1 + min(3,ceil(power_level/5))
	
	var enemys_to_pick = []
	var enemys_in_range = enemy_list
	
	while enemys_to_pick.size() < count:
		var new_enemy_list = []
		for i in enemys_in_range:
			if i["Level"] < power_level:
				new_enemy_list.append(i)
		enemys_in_range = new_enemy_list
		if enemys_in_range.size() < 1:
			print("No Enemys at this power Level")
			return enemys_to_pick
		
		var enemy = enemys_in_range[rng.randi_range(0,enemys_in_range.size()-1)]
		enemy = load_character(enemy)
		enemys_to_pick.append(enemy)
		power_level -= enemy.level
		
	return enemys_to_pick

#Baurche ich das?
func get_fighter():
	var fighters = []
	var heros = []

func get_power_range():
	var mid_level = ceil(GameData.power_level/4)
	var min_level = max(1,mid_level-2)
	var max_level = mid_level + 1
	return [min_level,max_level]
