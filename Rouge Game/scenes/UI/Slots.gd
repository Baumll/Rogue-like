extends Panel



export(int) var equip_slots = 2
var cell_width = 240
var cell_height = 240
onready var storage = get_node("/root/Main").inventory
onready var rows = get_node("/root/Main").inventory.rows
onready var collums = get_node("/root/Main").inventory.collums
var equip = []
var image_storage = []
var image_equip = []

#onready var inv = get_node("/root/Main").inventory
onready var papa = get_tree().get_root().find_node("inventorySlots")
var activeCharacter = null


		
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(rows * collums):
		image_storage.append(null)
	for x in range(0,equip_slots):
		equip.append(null)
		image_equip.append(null)
	if storage.inventory == null:
		storage.inventory = []
		for i in range(rows * collums):
			storage.inventory.append(null)



func get_container(item):
	var num = storage.inventory.find(item)
	return image_storage[num]

func drop_item(item, pos, prev_pos, carry_item) -> bool:
	if(pos.x < collums && pos.y < rows && pos.x >= 0 && pos.y >= 0):
		if storage.inventory[pos.y * collums + pos.x] == null:
			set_item(item, pos, carry_item)
			return true
		else:
			if(prev_pos.x >= collums):
				set_quipp(storage.inventory[pos.y * collums + pos.x], prev_pos.y)
				set_item(item, pos,carry_item)
			else:
				set_item(storage.inventory[pos.y * collums + pos.x], prev_pos)
				set_item(item, pos,carry_item)
		return true
	#Wenn man es in den Equip slot packt
	elif pos.x >= collums && pos.y >= 0 && pos.y < equip.size(): #Equipp 0
		if equip[pos.y] == null:
			set_quipp(item, pos.y,carry_item)
		else :
			if(prev_pos.x >= collums):
				set_quipp(equip[pos.y], prev_pos.y,image_equip[pos.y])
				set_quipp(item, pos.y,carry_item)
			else:
				set_item(equip[pos.y], prev_pos,image_equip[pos.y])
				set_quipp(item, pos.y,carry_item)
	elif pos.x >= collums && pos.y >= equip.size() && pos.y < equip.size()+1:
		carry_item.queue_free()
		item = null
	else:
		if(prev_pos.x >= collums):
			set_quipp(item, prev_pos.y,carry_item)
		else:
			set_item(item, prev_pos,carry_item)
	carry_item = null
	return true

#global mouse Position
func drag_item(mouse_pos):
	var carry_item = null
	if(activeCharacter != null):
		var item = null
		var pos = get_slot(mouse_pos)
		if(pos.x == collums && pos.y >= 0 && pos.y < equip.size()):
			item = equip[pos.y]
			carry_item = image_equip[pos.y]
			equip[pos.y] = null
			image_equip[pos.y] = null
			activeCharacter.equip[pos.y] = null
			activeCharacter.reset_stats()
			activeCharacter.calculate_all_stats()
		else:
			if( storage.inventory.size() > pos.y * collums + pos.x):
				item = storage.inventory[pos.y * collums + pos.x]
				storage.inventory[pos.y * collums + pos.x] = null
				carry_item = image_storage[pos.y * collums + pos.x]
				image_storage[pos.y * collums + pos.x] = null
		#inv.save_inventory(storage.inventory)
		return [item, carry_item]
	return [null,null]

func set_item(item, pos, container = null):
	if(item != null):
		if container == null:
			container = get_container(item)
		container.setPos(rect_position + Vector2(pos.x * cell_width  + rect_position.x, pos.y * cell_height + rect_position.y))
		image_storage[pos.y * collums + pos.x] = container
		storage.inventory[pos.y * collums + pos.x] = item
		#main.save_inventory(storage.inventory)

#global mouse Position
func get_slot(mouse_pos) -> Vector2:
	var localPos = mouse_pos - rect_global_position
	return Vector2(floor(localPos.x /cell_height),floor(localPos.y /cell_width))

func add_item(item, container) -> bool:
	for x in range(0, storage.inventory.size()):
		if storage.inventory[x] == null:
			storage.inventory[x] = item
			image_storage[x] = container
			container.setPos( Vector2(fmod(x,rows)*cell_width + rect_position.x, floor(x/collums)*cell_height + rect_position.y) )
			#inv.save_inventory(storage.inventory)
			return true
			
	return false

#Setzt ein item in den Equip slot
func set_quipp(item , num, container = null):
	if(item != null):
		if container == null:
			container = get_container(item)
		container.setPos(rect_position + Vector2(collums * cell_width + rect_position.x , num * cell_width + rect_position.y))
		image_equip[num] = container
		equip[num] = item
		activeCharacter.equip[num] = item
		activeCharacter.calculate_all_stats()
		#main.save_inventory(storage.inventory)
		#main.character_add_item_stats(main.activeChracter)

func slot_free() -> bool:
	for x in range(0, storage.inventory.size()):
		if storage.inventory[x] == null:
			return true
	return false

func add_item_pos(item, pos):
	if(pos.x < collums && pos.y < rows && pos.x >= 0 && pos.y >= 0):
		if storage.inventory[pos.y * collums + pos.x] == null:
			set_item(item, pos)
			return true
		else:
			for i in storage.inventory:
				if i == null:
					set_item(item, pos)
		return true
	#Wenn man es in den Equip slot packt
	elif pos.x >= collums && pos.y >= 0 && pos.y < equip.size(): #Equipp 0
		if equip[pos.y] == null:
			set_quipp(item, pos.y)
		else :
			for i in storage.inventory:
				if i == null:
					set_item(item, pos)
	else:
		for i in storage.inventory:
			if i == null:
				set_item(item, pos)
	return true


