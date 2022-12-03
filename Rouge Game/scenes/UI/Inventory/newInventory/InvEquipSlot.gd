extends Button

signal ItemSet(item)
signal bought(item)

var item
var num = -1
var active = true
var forSale = true

onready var label = $Label
onready var textureRect = $TextureRect
onready var texIcon = $TexIcon

var activeCaracter = null 

func _ready():
	label.text = ""
	textureRect.visible = false

func get_drag_data(_position):
	if item != null and active:
		#Daten die bei drag and drop übergebn werden
		var data = {}
		data["origin_kind"] = "equip"
		data["origin_item"] = item
		data["origin_slot"] = self
		
		#Erstellen des Icons was der mausfolgt
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = item.icon
		drag_texture.rect_size = Vector2(200,200)
		#Neuer Node folgt der Maus
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		set_drag_preview(control)
		
		
		texIcon.texture = null
		textureRect.visible = false
		label.text = ""
		
		emit_signal("ItemSet",item)
		
		activeCaracter.remove_item(num)
		item = null
		return data
	
func can_drop_data(_position, data):
	#Check if we can drop an item in this slot
	if(data["origin_kind"] == "shop" and item != null):
		return false
	if activeCaracter != null:
		#for i in range(activeCaracter.equip.size()):
		#	if activeCaracter.equip[i] != null and i != num and data["origin_kind"] != "equip":
		#		if activeCaracter.equip[i].name == data["origin_item"].name:
		#			return false
		return true
	else:
		return false
	
	
func drop_data(_pos,data):
	#What happens when we drop an item in this slot
	
	data["origin_slot"].set_item(item)
	set_item(data["origin_item"])

	if(data["origin_kind"] == "shop"):
		emit_signal("bought",data["origin_item"])

	
func set_item(newItem):
	if(newItem != null):
		#emit_signal("ItemSet",newItem,num)
		#löscht das aktuelle item
		activeCaracter.remove_item(num)
		
		item = newItem
		texIcon.texture = item.icon
		activeCaracter.add_item(num,item)
		if forSale:
			label.text = str(item.value) + "G"
			textureRect.visible = true
	else:
		#emit_signal("ItemSet",null,num)
		item = null
		texIcon.texture = null
		label.text = ""
		textureRect.visible = false


func _process(_delta):
	if Input.is_action_just_released("ui_mouse_left"):
		if(item != null):
			texIcon.texture = item.icon
			if forSale:
				label.text = str(item.value) + "G"
				textureRect.visible = true

func set_sale(state):
	forSale = state


func _on_InvEquipSlot1_button_down():
	if item != null:
		emit_signal("ItemSet",item)
