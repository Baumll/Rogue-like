extends Control

signal needDescription(state)
signal loadChars(chars)
signal setCharcterActive(character)
signal exit()


onready var expProgess = $VBox/TextureProgress

onready var rect = $VBox/HBox/TextureRect
onready var gold = $GoldSign

onready var ui_under = $VBox/Ui_Under

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("setCharcterActive",GameData.active_character)

func _process(_delta):
	load_character(GameData.active_character)
	$VBox/HBox.rect_size = Vector2(1080,720)

func load_character(character):
	if character != null:
		rect.texture = character.image
		set_xp(character.experience_points, character.base_exp_to_level*character.level)

func load_all_chracters(args):
	for x in args:
		load_character(x)
	#ui_under.load_characters(args)

func set_xp(amount, maximal):
	if maximal != 0:
		expProgess.set_value(round((float(amount)/float(maximal))*100.0))

func _on_Ui_Under_back():
	emit_signal("exit")
