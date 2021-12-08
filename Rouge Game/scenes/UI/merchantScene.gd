extends Control

export(int) var itemCount = 3
var itemToBuy = []
var itemSize = 240
onready var slots = $Panel


func _ready():
	setup_items()

func drag(mouse_pos) -> Object:
	if itemToBuy.size() > get_slot(mouse_pos) && get_slot(mouse_pos) >= 0:
		if( itemToBuy[get_slot(mouse_pos)] != null):
			var item = itemToBuy[get_slot(mouse_pos)]
			itemToBuy[get_slot(mouse_pos)] = null
			return item
	return null

func put_item_back(item):
	for i in range(itemToBuy.size()):
		if itemToBuy[i] == null:
			itemToBuy[i] = item
			var pos = Vector2(slots.rect_global_position.x  + item.rect_size.x * i, slots.rect_global_position.y)
			item.rect_global_position = pos

func add_item(item):
	for i in range(itemToBuy.size()):
		if itemToBuy[i] == null:
			itemToBuy[i] = item
			var pos = Vector2(slots.rect_global_position.x  + item.rect_size.x * i, slots.rect_global_position.y)
			item.rect_global_position = pos
			return

func setup_items():
	for i in itemToBuy:
		if i != null:
			i.queue_free()
	itemToBuy = []
	for x in range(itemCount):
		itemToBuy.append(null)

func remove_items():
	for i in itemToBuy:
		if i != null:
			i.queue_free()
			i = null

func get_slot(mouse_pos) -> int:
	var localPos = mouse_pos - slots.rect_global_position
	if( localPos.y >= 0 and localPos.y <= slots.rect_size.y):
		return int(floor(localPos.x / (itemSize)))
	else:
		return -1
		
func slot_free() -> bool:
	for i in itemToBuy:
		if i == null:
			return true
	return false



