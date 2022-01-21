extends Control

signal inventoryButton
signal itemSold(item)
signal descriptionText(text)

export(int) var gold = 0

#onready var inventory = get_node("/root/main/Control/VBoxContainer/inventory")
var carry_item = [null,null]
var carry_prev_pos : Vector2 = Vector2(0,0)
onready var slots = $HBomb/Slots
onready var button = $HBomb/VBoxContainer/Button
onready var merchant = null
onready var goldSign = null#get_node("/root/Main/Control/GoldSign")
onready var descriptionText = null
export(bool) var enable_inventory = true

onready var trashIcon = preload("res://Assets/images/Icons/Inventory/clipart2564646.png")

func _ready():
	var inv = get_node("/root/Main").inventory
	if inv != null:
		for i in range(inv.rows * inv.collums):
			if inv.inventory[i] != null:
				var new_item = load("res://scenes/UI/Inventory/Item.tscn")
				var item_instance2 = new_item.instance()
				add_child(item_instance2)
				item_instance2.set_image(inv.inventory[i].image)
				slots.set_item(inv.inventory[i], Vector2(fmod(i,inv.collums), floor(i/inv.rows)),item_instance2)

func _process(delta):
	if carry_item != [null,null]:
		carry_item[1].rect_position = get_local_mouse_position() - (carry_item[1].rect_size/2)
		
	#Item wird aufgehoben
	if(enable_inventory):
		if(Input.is_action_just_pressed("ui_mouse_left")):
			if (get_global_mouse_position().x >= slots.rect_global_position.x && get_global_mouse_position().y >= slots.rect_global_position.y):
				carry_item = slots.drag_item(get_global_mouse_position())
				if carry_item != [null,null]:
					remove_child(carry_item[1])
					add_child(carry_item[1])
					carry_prev_pos = slots.get_slot(get_global_mouse_position())
					emit_signal("descriptionText", carry_item[0].description)
					button.icon = trashIcon
					button.text = ""
			elif merchant != null:
				carry_item = merchant.drag(get_global_mouse_position())
				if carry_item != null:
					remove_child(carry_item[1])
					add_child(carry_item[1])
					carry_prev_pos = Vector2(-2,-2)
					descriptionText.set_text(carry_item[0].description)
					button.icon = trashIcon
					button.text = ""
			
	#item wird losgelassen
		if(Input.is_action_just_released("ui_mouse_left")):
			if(carry_item != null):
				if carry_prev_pos != Vector2(-2,-2): #Vector2
					if (get_global_mouse_position().x >= slots.rect_global_position.x && get_global_mouse_position().y >= slots.rect_global_position.y): #Equipen, umräumen etc
						print("Move")
						if slots.drop_item(carry_item[0],slots.get_slot(get_global_mouse_position()), carry_prev_pos,carry_item[1]):
							carry_item = [null,null]
							carry_prev_pos = Vector2(-1,-1)
					elif merchant != null: #Verkaufen
						print("sell")
						gold += carry_item.value
						carry_item[1].queue_free()
						carry_item = [null,null]
						carry_prev_pos = Vector2(-1,-1)
						goldSign.set_gold(gold)
				elif carry_prev_pos == Vector2(-2,-2):  #Int
					if (get_global_mouse_position().x >= slots.rect_global_position.x && get_global_mouse_position().y >= slots.rect_global_position.y): #Kaufen
						print("buy")
						if gold >= carry_item[1].value && slots.slot_free():
							gold -= carry_item[1].value
							slots.add_item_pos(carry_item[1], slots.get_slot(get_global_mouse_position()) )
							carry_item = [null,null]
							carry_prev_pos = Vector2(-1,-1)
							goldSign.set_gold(gold)
						else:
							merchant.put_item_back(carry_item)
							carry_item = [null,null]
							carry_prev_pos = Vector2(-1,-1)
					else: #Zurrück Packen
						print("Put Back")
						merchant.put_item_back(carry_item)
						carry_item = [null,null]
						carry_prev_pos = Vector2(-1,-1)
				button.icon = null
				button.text = "Back"
		
		if(Input.is_action_just_pressed("ui_up")):
			create_item()


func create_item():
	if(slots.slot_free()):
		var new_item = load("res://ScribtAble/ClassItem.gd")
		var item_instance = new_item.new()
		item_instance._ready()
		new_item = load("res://scenes/UI/Inventory/Item.tscn")
		var item_instance2 = new_item.instance()
		add_child(item_instance2)
		item_instance2.set_image(item_instance.image)
		slots.add_item(item_instance,item_instance2)
		

func create_item_to_sell():
	if merchant.slot_free():
		var new_item = load("res://ScribtAble/ClassItem.gd")
		var item_instance = new_item.new()
		item_instance._ready()
		merchant.add_item(item_instance)

func load_equip(character):
	slots.activeCharacter = character
	var new_item
	for i in slots.equip:
		if i != null:
			print(i)
			#remove_child(i)
			#i.queue_free()
			#i = null
	if(character == null):
		return
	if(character.equip[0] != null):
		new_item = load("res://scenes/UI/Inventory/Item.tscn")
		var item_instance = new_item.instance()
		add_child(item_instance)
		item_instance.set_image(character.equip[0].image)
		slots.set_quipp(character.equip[0],0,item_instance)
		
	if(character.equip[1] != null):
		new_item = load("res://scenes/UI/Inventory/Item.tscn")
		var item_instance2 = new_item.instance()
		add_child(item_instance2)
		item_instance2.set_image(character.equip[1].image)
		slots.set_quipp(character.equip[1],1,item_instance2)
	
func reset():
	for i in slots.storage.inventory:
		if i != null:
			i.queue_free()
			i = null

func _on_set_gold_descr(gold, description):
	goldSign = gold
	descriptionText = description
	goldSign.set_gold(gold)

func _on_mercant_start(merc, gold, description):
	set_gold(true)
	merchant = merc
	goldSign = gold
	descriptionText = description
	goldSign.set_gold(gold)
	create_item_to_sell()
	create_item_to_sell()
	create_item_to_sell()

func set_gold(state):
	for i in get_children():
		if i.name != "HBomb":
			i.set_show_value(state)

func _on_Button_button_up():
	emit_signal("inventoryButton")

