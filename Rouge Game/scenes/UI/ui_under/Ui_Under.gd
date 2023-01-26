extends Control

signal move_num_up(num)
signal move_num_down(num)
signal move_clicked(move)
signal selected_character(character)
signal merchant(broker)
signal back

onready var charSelect = $VBox/HBox/CharSelect
onready var attackButtons = $VBox/AttackButtons
onready var inventory = $VBox/NewInventory
onready var description = $VBox/DecriptinText

#Alles was der unter teil des Bildschirms ist.
# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.set_active_state(false)
	#load_characters(GameData.heros)


func load_characters(chars):
	for i in chars:
		charSelect.add_character(i)

func add_character(arg):
	charSelect.add_character(arg)

func set_s(character):
	charSelect.set_char_active(character)

func set_description(state):
	description.visible = state

func set_charSelect(state):
	charSelect.visible = state

func show_attacks():
	attackButtons.visible = true

func show_inventory():
	attackButtons.visible = false

func add_item(item = null):
	inventory.create_item(item)

func _on_CharSelect_move_pressed(move):
	emit_signal("move_clicked",move)
	set_description_move(move)

func _on_inventorySlots_inventoryButton():
	emit_signal("back")

func set_description_move(move):
	description.set_move_text(move)

func set_inventory():
	attackButtons.visible = false
	inventory.set_active_state(true)


func _on_CharSelect_mun_selected():
	#zwischen inventar und buttons toggeln
	if attackButtons.visible == true:
		attackButtons.visible = false
		inventory.set_active_state(true)
	else:
		attackButtons.visible = true
		inventory.set_active_state(false)

func _on_CharSelect_char_selected(character):
	emit_signal("selected_character",character)


func _on_AttackButtons_attackUP(num):
	emit_signal("move_num_up",num)


func _on_AttackButtons_attackDown(num):
	emit_signal("move_num_down",num)


func _on_merchant_merchant(broker):
	set_inventory()
	emit_signal("merchant",broker)
