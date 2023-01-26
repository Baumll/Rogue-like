extends Control

signal inventoryButton
signal ItemDescription(item)

onready var grid = $HBoxContainer/GridContainer
onready var equip = $HBoxContainer/VBoxContainer/EquipSlots

onready var itemContainer = preload("res://scenes/UI/Inventory/newInventory/InvSlot1.tscn")
var slotList = []
#var activeCharacter = null
var collums = GlobalFunktions.inventory_collums
var rows = GlobalFunktions.inventory_rows

func _ready():
	var inv = GameData.inventory
	grid.columns = collums
	for i in range(0,rows*collums):
		var container = itemContainer.instance()
		grid.add_child(container)
		slotList.append(container)
		container.connect("ItemSet", self,"_on_item_pressed")
		container.connect("bought", self,"_on_item_bought")
		container.rect_size = Vector2(grid.rect_size.x/collums, grid.rect_size.y/rows)
		
		container.num = i
		container.inv = inv
		if inv.size() > i:
			if inv[i] != null:
				container.set_item(inv[i])
		else:
			inv.append(null)

func _process(_delta):
	if(Input.is_action_just_pressed("ui_up")):
		add_item()
	#refresh_inventory()

func refresh_inventory():
	for i in range(slotList.size()):
		slotList[i].set_item(GameData.inventory[i])
	
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
	GameData.gold -= item.value

func _on_CharSelect_char_selected(character):
	equip.set_equip(character)
	#character = activeCharacter


func _on_BackButton_pressed():
	emit_signal("inventoryButton")
