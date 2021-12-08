extends Node

var rng = RandomNumberGenerator.new()

signal selectCharacter(chracter)

enum states {
	start,
	charakter,
	door,
	fight,
	inventory,
	event,
	mercant,
	mercio
}
var state

export(Texture) var doorFight
export(Texture) var doorMercio
export(Texture) var doorMerchant
var doorPre = []

export(int) var maxCharacters = 3
var characterList = []
var activeChracter = null



onready var door = $Control/VBoxContainer/DoorScene
onready var start = $Control/Start
onready var character_screen = $Control/CharSelectScreen
onready var inventory = $Control/VBoxContainer/inventory
onready var attacks = $Control/VBoxContainer/AttackButtons
onready var two_choise = $Control/VBoxContainer/TwoChoise
onready var fight = $Control/VBoxContainer/FightScene
onready var character_panel = $Control/VBoxContainer/CharacterChoise2
onready var win_screen = $Control/WinSzene
onready var lose_screen = $Control/LoseSzene
onready var merchant_screen = $Control/VBoxContainer/merchant
onready var gold_sgin = $Control/GoldSign
onready var description_screen = $Control/VBoxContainer/DecriptinText
onready var mercioSceen = $Control/mercenario
onready var load_screen = $Control/VBoxContainer/LoadOut

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup_start()


func setup_start():
	disable_all()
	start.visible = true
	state = states.start

func setup_char_select():
	disable_all()
	character_screen.visible = true
	state = states.charakter

func setup_doors():
	disable_all()
	doorPre = []
	door.visible = true
	var num = 0
	var doors = []
	rng.randomize()
	for i in range(2):
		if( characterList.size() < 3):
			num = rng.randi_range(0,2)
		else:
			num = rng.randi_range(0,1)
		match num:
			0:
				doors.append(doorFight)
				doorPre.append(states.fight)
			1:
				doors.append(doorMercio)
				doorPre.append(states.mercio)
			2:
				doors.append(doorMerchant)
				doorPre.append(states.mercant)
	door.setup_doors(doors[0], doors[1])
	two_choise.visible = true
	state = states.door

func enter_door():
	var num = 0
	rng.randomize()
	if( characterList.size() < 3):
		num = rng.randi_range(0,2)
	else:
		num = rng.randi_range(0,1)
	match num:
		0:
			setup_fight()
		1:
			setup_merchant()
		2:
			setup_mercinario()

func setup_fight():
	disable_all()
	inventory.visible = true
	inventory.enable_inventory = false
	attacks.visible = true
	attacks.margin_right = -360
	fight.visible = true
	character_panel.visible = true
	fight.pacifism = false
	fight.setup_fight()
	fight.add_fighter(load_enemy(),0)
	fight.add_fighter(load_enemy(),0)
	fight.add_fighter(load_enemy(),0)
	load_characters_fight()
	fight.start_fight()

func setup_win_screen():
	disable_all()
	win_screen.visible = true
	
func setup_lose_screen():
	disable_all()
	inventory.reset()
	lose_screen.visible = true

func setup_merchant():
	disable_all()
	character_panel.visible = true
	inventory.visible = true
	merchant_screen.visible = true
	merchant_screen.setup_items()
	gold_sgin.visible = true
	description_screen.visible = true
	inventory.merchantActive = true
	inventory.enable_inventory = true
	inventory.create_item_to_sell()
	inventory.create_item_to_sell()
	inventory.create_item_to_sell()

func setup_mercinario():
	disable_all()
	mercioSceen.visible = true


func setup_load_out():
	disable_all()
	description_screen.visible = true
	load_screen.visible = true
	inventory.visible = true
	inventory.enable_inventory = true
	character_panel.visible = true
	load_screen.load_character(activeChracter)
	attacks._on_FightScene_loadAttacks(activeChracter.moves)
	attacks.margin_right = -360

func disable_all():
	merchant_screen.visible = false
	merchant_screen.remove_items()
	door.visible = false
	start.visible = false
	character_screen.visible = false
	inventory.visible = false
	inventory.enable_inventory = false
	inventory.merchantActive = false
	attacks.visible = false
	two_choise.visible = false
	fight.visible = false
	fight.pacifism = true
	character_panel.visible = false
	win_screen.visible = false
	lose_screen.visible = false
	gold_sgin.visible = false
	description_screen.visible = false
	mercioSceen.visible = false
	load_screen.visible = false

func load_enemy() -> Resource:
	var preChar = load("res://Units/CharacterSzene.tscn")
	var character = preChar.instance()
	var i = rng.randi_range(-1.0,1.0)
	if i > 0:
		character.load_path("res://Units/enemys/UnitSkelett.tres")
	else:
		character.load_path("res://Units/enemys/UnitZombie.tres")
	
	return character

func load_characters_fight():
	for x in characterList:
		fight.add_fighter(x, 1)
	
func _on_Start_start_pressed():
	character_panel.reset()
	setup_char_select()


func _on_CharacterChoise_char_selected(num):
	if num != -1:
		if characterList.size() > num:
			activeChracter = characterList[num]
			inventory.load_equip(characterList[num])
			emit_signal("selectCharacter",characterList[num])
			load_screen.load_character(activeChracter)
			attacks._on_FightScene_loadAttacks(activeChracter.moves)
	else: #Swap between Inventory and Attacks in Loadout
		if( load_screen.visible == true):
			if attacks.visible == false:
				inventory.enable_inventory = false
				attacks.visible = true
			else:
				inventory.enable_inventory = true
				attacks.visible = false



func _on_DoorScene_door_enter(num):
	match doorPre[num]:
		states.fight:
			setup_fight()
		states.mercio:
			setup_mercinario()
		states.mercant:
			setup_merchant()
		


func _on_TwoChoise_choise_made(num):
	if(state == states.door):
		setup_load_out()


func _on_CharSelectScreen_Chosen(num):
	load_chracter(num)
	setup_doors()


func _on_FightScene_endFight(team):
	if(team == 1):
		setup_win_screen()
		inventory.create_item()
	else:
		setup_lose_screen()


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
		var preChar = load("res://Units/CharacterSzene.tscn")
		var character = preChar.instance()
		match num:
			0: 
				character.load_path("res://Units/Characters/charMage.tres")
			1: 
				character.load_path("res://Units/Characters/charWarrier.tres")
			2: 
				character.load_path("res://Units/Characters/charRanger.tres")
			3: 
				character.load_path("res://Units/Characters/charNecro.tres")
		characterList.append(character)
		character_panel.add_character(characterList[characterList.size()-1])
		activeChracter = characterList[characterList.size()-1]
		activeChracter.health = activeChracter.maxHealth
		character_reset_stats(activeChracter)
		inventory.load_equip(activeChracter)
		print(characterList)

func character_reset_stats(character):
	character.maxHealth = character.baseMaxHealth
	character.streng = character.baseStreng
	character.defence = character.baseDefence
	character.dexterity = character.baseDexterity
	character.magic = character.baseMagic
	character.speed = character.baseSpeed
	character.healProcent = 0.0
	character.damgeProcent = 0.0
	character.protectProcent = 0.0
	
func character_add_item_stats(character):
	for i in character.equip:
		if i != null:
			var item = load(i)
			character.maxHealth += item.maxHealth
			character.streng += item.streng
			character.defence += item.defence
			character.dexterity += item.dexterity
			character.magic += item.magic
			character.speed += item.speed
			character.healProcent = item.healProcent
			character.damgeProcent = item.damgeProcent
			character.protectProcent = item.protectProcent
	load_screen.load_character(activeChracter)




func _on_AttackButtons_attack(num):
	if num == -1:
		setup_doors()

