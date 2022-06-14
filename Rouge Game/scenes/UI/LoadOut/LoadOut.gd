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
	TextContainer.get_child(1).text = ("Level: " + String(character.level))
	TextContainer.get_child(2).set_text("Health: " + String(character.health) +"/" + String(character.maxHealth))
	TextContainer.get_child(3).set_text("Armor: " + String(character.defence))
	TextContainer.get_child(4).set_text("Mag. Def.: " + String(character.magicDefence))
	TextContainer.get_child(5).set_text("Strength: " + String(character.strength))
	TextContainer.get_child(6).set_text("Magic: " + String(character.magic))
	TextContainer.get_child(7).set_text("Dexterity: " + String(character.dexterity))
	TextContainer.get_child(8).set_text("Speed: " + String(character.speed))
	lableName.update()
	set_xp(character.experiencePoints, character.baseExpToLevel*character.level)
	TextContainer.add_constant_override("separation", 0)
	if character.skillPoints > 1:
		set_level_up(true)

func load_all_chracters(args):
	for x in args:
		load_character(x)
	#ui_under.load_characters(args)

func set_xp(amount, maximal):
	if maximal != 0:
		expProgess.set_value(round((float(amount)/float(maximal))*100.0))

func _on_Ui_Under_back():
	emit_signal("exit")


func set_level_up(state):
	for i in TextContainer.get_children():
		if ! "Label" in i.name:
			i.set_level_up(state)



func _on_levelUp_health(num):
	acktive_character.baseMaxHealth += 5
	acktive_character.skillPoints -= 1
	ChrFunc.calculate_all_stats(acktive_character)
	ChrFunc.reset_health(acktive_character)
	if acktive_character.skillPoints <= 0:
		set_level_up(false)

func _on_levelUp_defence(num):
	acktive_character.baseDefence += 1
	acktive_character.skillPoints -= 1
	ChrFunc.calculate_all_stats(acktive_character)
	if acktive_character.skillPoints <= 0:
		set_level_up(false)

func _on_levelUp_magicDefence(num):
	acktive_character.baseMagicDefence += 1
	acktive_character.skillPoints -= 1
	ChrFunc.calculate_all_stats(acktive_character)
	if acktive_character.skillPoints <= 0:
		set_level_up(false)
		
func _on_levelUp_strenght(num):
	acktive_character.baseStrength += 1
	acktive_character.skillPoints -= 1
	ChrFunc.calculate_all_stats(acktive_character)
	if acktive_character.skillPoints <= 0:
		set_level_up(false)

func _on_levelUp_magic(num):
	acktive_character.baseMagic += 1
	acktive_character.skillPoints -= 1
	ChrFunc.calculate_all_stats(acktive_character)
	if acktive_character.skillPoints <= 0:
		set_level_up(false)

func _on_levelUp_dexterity(num):
	acktive_character.baseDexterity += 1
	acktive_character.skillPoints -= 1
	ChrFunc.calculate_all_stats(acktive_character)
	if acktive_character.skillPoints <= 0:
		set_level_up(false)

func _on_levelUp_speed(num):
	acktive_character.baseSpeed += 1
	acktive_character.skillPoints -= 1
	ChrFunc.calculate_all_stats(acktive_character)
	if acktive_character.skillPoints <= 0:
		set_level_up(false)
