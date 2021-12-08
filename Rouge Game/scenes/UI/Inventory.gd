extends Control

signal inventoryButton
signal itemSold(item)

export(int) var gold = 0

#onready var inventory = get_node("/root/main/Control/VBoxContainer/inventory")
var carry_item : Object = null
var carry_prev_pos : Vector2 = Vector2(0,0)
onready var slots = $HBomb/Slots
onready var merchant = get_node("/root/Main/Control/VBoxContainer/merchant/")
onready var goldSign = get_node("/root/Main/Control/GoldSign")
onready var descriptionText = get_node("/root/Main/Control/VBoxContainer/DecriptinText")


export(bool) var enable_inventory = true
var merchantActive = false

func _ready():
	goldSign.set_gold(gold)

func _process(delta):
	if carry_item != null:
		carry_item.rect_position = get_local_mouse_position() - (carry_item.rect_size/2)
		
	#Item wird aufgehoben
	if(enable_inventory):
		if(Input.is_action_just_pressed("ui_mouse_left")):
			if (get_global_mouse_position().x >= slots.rect_global_position.x && get_global_mouse_position().y >= slots.rect_global_position.y):
				carry_item = slots.drag_item(get_global_mouse_position())
				if carry_item != null:
					remove_child(carry_item)
					add_child(carry_item)
					carry_prev_pos = slots.get_slot(get_global_mouse_position())
					descriptionText.set_text(carry_item.description)
			elif merchantActive:
				carry_item = merchant.drag(get_global_mouse_position())
				if carry_item != null:
					remove_child(carry_item)
					add_child(carry_item)
					carry_prev_pos = Vector2(-2,-2)
					descriptionText.set_text(carry_item.description)
			
	#item wird losgelassen
	if(Input.is_action_just_released("ui_mouse_left")):
		if(carry_item != null):
			if carry_prev_pos != Vector2(-2,-2): #Vector2
				if (get_global_mouse_position().x >= slots.rect_global_position.x && get_global_mouse_position().y >= slots.rect_global_position.y): #Equipen, umräumen etc
					print("Move")
					if slots.drop_item(carry_item,slots.get_slot(get_global_mouse_position()), carry_prev_pos):
						carry_item = null
						carry_prev_pos = Vector2(-1,-1)
				elif merchantActive: #Verkaufen
					print("sell")
					gold += carry_item.value
					carry_item.queue_free()
					carry_item = null
					carry_prev_pos = Vector2(-1,-1)
					goldSign.set_gold(gold)
			elif carry_prev_pos == Vector2(-2,-2):  #Int
				if (get_global_mouse_position().x >= slots.rect_global_position.x && get_global_mouse_position().y >= slots.rect_global_position.y): #Kaufen
					print("buy")
					if gold >= carry_item.value && slots.slot_free():
						gold -= carry_item.value
						slots.add_item_pos(carry_item, slots.get_slot(get_global_mouse_position()) )
						carry_item = null
						carry_prev_pos = Vector2(-1,-1)
						goldSign.set_gold(gold)
					else:
						merchant.put_item_back(carry_item)
						carry_item = null
						carry_prev_pos = Vector2(-1,-1)
				else: #Zurrück Packen
					print("Put Back")
					merchant.put_item_back(carry_item)
					carry_item = null
					carry_prev_pos = Vector2(-1,-1)

	
	if(Input.is_action_just_pressed("ui_mouse_right")):
		create_item()


func create_item():
	if(slots.slot_free()):
		var new_item = load("res://Items/Item.tscn")
		var item_instance = new_item.instance()
		add_child(item_instance)
		slots.add_item(item_instance)

func create_item_to_sell():
	if merchant.slot_free():
		var new_item = load("res://Items/Item.tscn")
		var item_instance = new_item.instance()
		add_child(item_instance)
		merchant.add_item(item_instance)

func load_equip(character):
	var new_item
	for i in slots.equip:
		if i != null:
			print(i)
			remove_child(i)
			i.queue_free()
			i = null
	if(character.equip[0] != null and character.equip[0] != ""):
		new_item = load("res://Items/Item.tscn")
		var item_instance = new_item.instance()
		add_child(item_instance)
		item_instance.load_item(character.equip[0])
		slots.set_quipp(item_instance, 0)
		
	if(character.equip[1] != null and character.equip[1] != ""):
		new_item = load("res://Items/Item.tscn")
		var item_instance2 = new_item.instance()
		add_child(item_instance2)
		item_instance2.load_item(character.equip[1])
		slots.set_quipp(item_instance2, 1)
	

func reset():
	for i in slots.storage:
		if i != null:
			i.queue_free()
			i = null

func _on_Button_pressed():
	emit_signal("inventoryButton")

