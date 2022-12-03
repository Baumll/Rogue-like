extends Control

signal inventoryButton
signal ItemDescription(item)

onready var grid = $HBoxContainer/GridContainer
onready var equip = $HBoxContainer/VBoxContainer/EquipSlots

onready var itemContainer = preload("res://scenes/UI/Inventory/newInventory/InvSlot1.tscn")
onready var inf = get_node("/root/Main").inventory
onready var gold = get_node("/root/Main").gold
var slotList = []
#var activeCharacter = null

var rows = 3
var collums = 3


func _ready():
	grid.columns = collums
	for i in range(0,rows*collums):
		var container = itemContainer.instance()
		grid.add_child(container)
		slotList.append(container)
		container.connect("ItemSet", self,"_on_item_pressed")
		container.connect("bought", self,"_on_item_bought")
		container.num = i
		container.inf = inf
		if inf.size() > i:
			if inf[i] != null:
				container.set_item(inf[i])
		else:
			inf.append(null)
		

func _process(_delta):
	if(Input.is_action_just_pressed("ui_up")):
			add_item()

func add_item(item = null):
	for i in grid.get_children():
		if i.item == null:
			i.set_item(GlobalFunktions.create_item(item))
			return

func set_active_state(state):
	for i in slotList:
		i.active = state
	equip.set_active_state(state)

func _on_item_pressed(item):
	if item != null:
		emit_signal("ItemDescription", item)

func _on_item_bought(item):
	get_node("/root/Main").gold -= item.value

func _on_CharSelect_char_selected(character):
	equip.set_equip(character)
	#character = activeCharacter


func _on_BackButton_pressed():
	emit_signal("inventoryButton")
