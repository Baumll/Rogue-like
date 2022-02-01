extends Control

signal exit
signal loadChars
signal merchant(broker)


export(int) var itemCount = 3
var itemSize = 240
onready var grid = $grid
onready var itemContainer = preload("res://scenes/UI/Inventory/newInventory/ShopSlot1.tscn")
onready var preItem  = preload("res://ScribtAble/ClassItem.gd")


func _ready():
	var chars = get_node("/root/Main").get_fighters()
	emit_signal("loadChars",chars)
	setup_items()
	emit_signal("merchant", self)
	


func setup_items():
	for x in range(itemCount):
		var container = itemContainer.instance()
		grid.add_child(container)
		#slotList.append(container)
		var item = preItem.new()
		item._ready()
		container.set_item(item)
		container.num = x


func _on_Ui_Under_back():
	emit_signal("exit")
