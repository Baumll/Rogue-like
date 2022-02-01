extends Panel


var equip = null

func drop(item):
	equip = item
	item.setPos(rect_position)

func drag() -> Object:
	var item = equip
	equip = null
	return item
	

