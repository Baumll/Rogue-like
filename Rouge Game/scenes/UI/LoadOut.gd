extends Control

signal needDescription(state)
signal loadChars(chars)
signal exit()

onready var lableName = $VBoxContainer/HBoxContainer/VBoxContainer/Label
onready var expProgess = $VBoxContainer/TextureProgress
onready var acktive_character = null

onready var rect = $VBoxContainer/HBoxContainer/CenterContainer/TextureRect
onready var gold = $GoldSign

onready var ui_under = $VBoxContainer/Ui_Under

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("needDescription",true)
	var chars = get_node("/root/Main").get_fighters()
	emit_signal("loadChars",chars)
	load_all_chracters(chars)

func _process(delta):
	if acktive_character != null:
		load_character(acktive_character)

func load_character(character):
	acktive_character = character
	rect.texture = character.image
	lableName.text = (str(character.klass) 
	+ "\nLevel: " + String(character.level)
	+ "\nHealth: " + String(character.health) +"/" + String(character.maxHealth) 
	+ "\nArmor: " + String(character.defence)
	+ "\nStrength: " + String(character.strength)
	+ "\nMagic: " + String(character.magic)
	+ "\nDexterity: " + String(character.dexterity)
	+ "\nSpeed: " + String(character.speed))
	lableName.update()
	set_xp(character.experiencePoints, character.baseExpToLevel*character.level)
	

func load_all_chracters(args):
	for x in args:
		load_character(x)
	#ui_under.load_characters(args)

func set_xp(amount, maximal):
	expProgess.set_value(round((float(amount)/float(maximal))*100.0))




func _on_Ui_Under_back():
	emit_signal("exit")
