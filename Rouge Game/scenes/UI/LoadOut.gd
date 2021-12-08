extends Control


onready var lableName = $HBoxContainer/VBoxContainer/Label
onready var lableHp = $HBoxContainer/VBoxContainer/Label2
onready var lableDef = $HBoxContainer/VBoxContainer/Label3
onready var lableStr = $HBoxContainer/VBoxContainer/Label4
onready var lableMag = $HBoxContainer/VBoxContainer/Label5
onready var lableDex = $HBoxContainer/VBoxContainer/Label6
onready var lableSpd = $HBoxContainer/VBoxContainer/Label7

onready var rect = $HBoxContainer/CenterContainer/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_character(character):
	rect.texture = character.image
	set_name(character.klass)
	set_hp(character.health, character.maxHealth)
	set_def(character.defence)
	set_str(character.streng)
	set_mag(character.magic)
	set_dex(character.dexterity)
	set_spd(character.speed)
	


func set_name(name):
	lableName.text = name
	lableName.update()


func set_hp(hp, maxHP):
	var bla = "HP: " + String(hp) +"/" + String(maxHP)
	lableHp.text = bla
	lableHp.update()

func set_def(def):
	lableDef.text = "Def: " + String(def)
	lableDef.update()
	
func set_str(streng):
	lableStr.text = "Str: " + String(streng)
	lableStr.update()

func set_mag(mag):
	lableMag.text = "Mag:" + String(mag)
	lableMag.update()
	
func set_dex(dex):
	lableDex.text = "Dex: " + String(dex)
	lableDex.update()
	
func set_spd(spd):
	lableSpd.text = "Spd: " + String(spd)
	lableSpd.update()
