extends TextureRect

signal ItemSet(item)

var item
var num = -1
var active = true
onready var label = $Label
onready var textureRect = $TextureRect

func get_drag_data(position):
	if item != null and active:
		if( get_node("/root/Main").gold > item.value):
			var data = {}
			data["origin_kind"] = "shop"
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
			texture = null
			textureRect.visible = false
			label.text = ""
			return data
	
func can_drop_data(position, data):
	#Check if we can drop an item in this slot
	return false
	


func set_item(newItem):
	get_node("/root/Main").inventory[num] = newItem
	if(newItem != null):
		emit_signal("ItemSet",newItem)
		item = newItem
		texture = item.icon
		label.text = str(item.value) + "G"
		textureRect.visible = true
	else:
		emit_signal("ItemSet",null)
		item = null
		texture = null
		label.text = ""
		textureRect.visible = false


func _process(delta):
	if Input.is_action_just_released("ui_mouse_left"):
		if(item != null):
			texture = item.icon
			label.text = str(item.value) + "G"
			textureRect.visible = true


func _on_Button_button_down():
	if item != null:
		emit_signal("ItemSet",item)
