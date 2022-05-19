extends Control

signal needDescription(state)
signal loadChars(chars)
signal exit()

onready var lableName = $VBoxContainer/HBoxContainer/VBoxContainer/Label
onready var TextContainer = $VBoxContainer/HBoxContainer/VBoxContainer
onready var expProgess = $VBoxContainer/TextureProgress
onready var acktive_character = null

onready var rect = $VBoxContainer/HBoxContainer/TextureRect
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
	$VBoxContainer/HBoxContainer.rect_size = Vector2(1080,720)

func load_character(character):
	acktive_character = character
	rect.texture = character.image
	lableName.text = (str(character.klass) )
	TextContainer.get_child(1).set_text("Level: " + String(character.level))
	TextContainer.get_child(2).set_text("Health: " + String(character.health) +"/" + String(character.maxHealth))
	TextContainer.get_child(3).set_text("Armor: " + String(character.defence))
	TextContainer.get_child(4).set_text("Strength: " + String(character.strength))
	TextContainer.get_child(5).set_text("Magic: " + String(character.magic))
	TextContainer.get_child(6).set_text("Dexterity: " + String(character.dexterity))
	TextContainer.get_child(7).set_text("Speed: " + String(character.speed))
	lableName.update()
	set_xp(character.experiencePoints, character.baseExpToLevel*character.level)
	TextContainer.add_constant_override("separation", 0)
	if character.skillPoints > 1:
		for i in TextContainer.get_children():
			if i.name != "Label":
				i.set_level_up(true)

func load_all_chracters(args):
	for x in args:
		load_character(x)
	#ui_under.load_characters(args)

func set_xp(amount, maximal):
	expProgess.set_value(round((float(amount)/float(maximal))*100.0))


func _on_LoadOutSkill_levelUp(num):
	pass # Replace with function body.


func _on_LoadOutSkill2_levelUp(num):
	pass # Replace with function body.


func _on_LoadOutSkill3_levelUp(num):
	pass # Replace with function body.


func _on_LoadOutSkill4_levelUp(num):
	pass # Replace with function body.


func _on_Ui_Under_back():
	emit_signal("exit")
