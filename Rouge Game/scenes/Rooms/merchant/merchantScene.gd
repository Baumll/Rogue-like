extends Control

signal exit
signal loadChars
signal merchant(broker)


export(int) var itemCount = 3
var itemSize = 240
onready var grid = $Control/grid
onready var itemContainer = preload("res://scenes/UI/Inventory/newInventory/ShopSlot1.tscn")


func _ready():
	var chars = GameData.heros
	emit_signal("loadChars",chars)
	setup_items()
	emit_signal("merchant", self)
	

func setup_items():
	for x in range(itemCount):
		var container = itemContainer.instance()
		grid.add_child(container)
		#slotList.append(container)
		container.set_item(GlobalFunktions.get_item_in_power_level())
		container.num = x

func _on_Ui_Under_back():
	emit_signal("exit")
