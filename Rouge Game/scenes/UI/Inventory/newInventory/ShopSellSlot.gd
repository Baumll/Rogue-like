extends TextureRect

signal ItemSet(item)


func get_drag_data(position):
	pass
	
func can_drop_data(position, data):
	#Check if we can drop an item in this slot
	return true
	

func drop_data(_pos,data):
	#What happens when we srop an item in this slot
	data["origin_slot"].set_item(null)
	get_node("/root/Main").gold += data["origin_item"].value