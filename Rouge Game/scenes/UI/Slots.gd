extends Panel


export(int) var rows = 3
export(int) var collums = 3
export(int) var equip_slots = 2
var cell_width = 240
var cell_height = 240
var storage = []
var equip = []

onready var main = get_node("/root/Main")

# Called when the node enters the scene tree for the first time.
func _ready():
	cell_height = rect_size.x/collums
	cell_width = rect_size.y/rows
	for x in range(0,rows * collums):
		storage.append(null)
	for x in range(0,equip_slots):
		equip.append(null)

func drop_item(item, pos, prev_pos) -> bool:
	if(pos.x < collums && pos.y < rows && pos.x >= 0 && pos.y >= 0):
		if storage[pos.y * collums + pos.x] == null:
			set_item(item, pos)
			return true
		else:
			if(prev_pos.x >= collums):
				set_quipp(storage[pos.y * collums + pos.x], prev_pos.y)
				set_item(item, pos)
			else:
				set_item(storage[pos.y * collums + pos.x], prev_pos)
				set_item(item, pos)
		return true
	#Wenn man es in den Equip slot packt
	elif pos.x >= collums && pos.y >= 0 && pos.y < equip.size(): #Equipp 0
		if equip[pos.y] == null:
			set_quipp(item, pos.y)
		else :
			if(prev_pos.x >= collums):
				set_quipp(equip[pos.y], prev_pos.y)
				set_quipp(item, pos.y)
			else:
				set_item(equip[pos.y], prev_pos)
				set_quipp(item, pos.y)
			
	else:
		if(prev_pos.x >= collums):
			set_quipp(item, prev_pos.y)
		else:
			set_item(item, prev_pos)
	return true

#global mouse Position
func drag_item(mouse_pos) -> Object:
	var item = null
	var pos = get_slot(mouse_pos)
	if(pos.x == collums && pos.y >= 0 && pos.y < equip.size()):
		item = equip[pos.y]
		equip[pos.y] = null
		main.activeChracter.equip[pos.y] = null
		main.character_reset_stats(main.activeChracter)
		main.character_add_item_stats(main.activeChracter)
	else:
		if( storage.size() > pos.y * collums + pos.x):
			item = storage[pos.y * collums + pos.x]
			storage[pos.y * collums + pos.x] = null
	return item
	

func set_item(item, pos):
	if(item != null):
		item.setPos(rect_position + Vector2(pos.x * cell_width  + rect_position.x, pos.y * cell_height + rect_position.y))
		storage[pos.y * collums + pos.x] = item

#global mouse Position
func get_slot(mouse_pos) -> Vector2:
	var localPos = mouse_pos - rect_global_position
	return Vector2(floor(localPos.x /cell_height),floor(localPos.y /cell_width))

func add_item(item) -> bool:
	for x in range(0, storage.size()):
		if storage[x] == null:
			storage[x] = item
			item.rect_position = Vector2(fmod(x,rows)*cell_width + rect_position.x, floor(x/collums)*cell_height + rect_position.y)
			return true
	return false

#Setzt ein item in den Equip slot
func set_quipp(item, num):
	if(item != null):
		item.setPos(rect_position + Vector2(collums * cell_width + rect_position.x , num * cell_width + rect_position.y))
		equip[num] = item
		main.activeChracter.equip[num] = item.source
		main.character_reset_stats(main.activeChracter)
		main.character_add_item_stats(main.activeChracter)

func slot_free() -> bool:
	for x in range(0, storage.size()):
		if storage[x] == null:
			return true
	return false

func add_item_pos(item, pos):
	if(pos.x < collums && pos.y < rows && pos.x >= 0 && pos.y >= 0):
		if storage[pos.y * collums + pos.x] == null:
			set_item(item, pos)
			return true
		else:
			for i in storage:
				if i == null:
					set_item(item, pos)
		return true
	#Wenn man es in den Equip slot packt
	elif pos.x >= collums && pos.y >= 0 && pos.y < equip.size(): #Equipp 0
		if equip[pos.y] == null:
			set_quipp(item, pos.y)
		else :
			for i in storage:
				if i == null:
					set_item(item, pos)
	else:
		for i in storage:
			if i == null:
				set_item(item, pos)
	return true


