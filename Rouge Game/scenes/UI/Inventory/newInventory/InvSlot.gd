extends Button

signal ItemSet(item)
signal bought(item)

var item
var num = -1
var active = true
var forSale = true
var inf = null

onready var label = $Label
onready var textureRect = $TextureRect
onready var texIcon = $TexIcon

var activeCaracter = null 

func _ready():
	label.text = ""
	textureRect.visible = false

func get_drag_data(_position):
	if item != null and active:
		var data = {}
		data["origin_kind"] = "inv"
		data["origin_item"] = item
		data["origin_slot"] = self
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = item.icon
		drag_texture.rect_size = Vector2(200,200)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.rect_position = -0.5 * drag_texture.rect_size
		set_drag_preview(control)
		
		if inf != null:
			inf[num] = null
		texIcon.texture = null
		textureRect.visible = false
		label.text = ""
		
		emit_signal("ItemSet",item)
		
		return data
	
func can_drop_data(_position, data):
	#Check if we can drop an item in this slot
	if(data["origin_kind"] == "shop" and item != null):
		return false
	else:
		return true
	
	
func drop_data(_pos,data):
	#What happens when we drop an item in this slot
	#Bei tausch
	data["origin_slot"].set_item(item)
	#Das ziel wird besetzt
	set_item(data["origin_item"])
	
	if(data["origin_kind"] == "shop"):
		emit_signal("bought",data["origin_item"])
	
func set_item(newItem):
	if(newItem != null):
		#emit_signal("ItemSet",newItem,num)
		item = newItem
		texIcon.texture = item.icon
		if inf != null:
			inf[num] = item
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

func _on_InvSlot1_button_down():
	if item != null:
		emit_signal("ItemSet",item)
