extends Container

export(Texture) var texture_slot
var rng = RandomNumberGenerator.new()
var item

export(int) var value = 10
export(String) var description = "Hier könnte ihre Werbung stehen"
var source

func _ready():
	rng.randomize()
	var ran = rng.randi_range(0,2)
	match ran:
		0:
			load_item("res://ScribtAble/Items/ItemDagger.tres")
			continue
		1:
			load_item("res://ScribtAble/Items/ItemHammer.tres")
			continue
		2:
			load_item("res://ScribtAble/Items/ItemBook.tres")
			continue

func load_item(path):
	if path != "" and path != null:
		item = load(path)
		source = path
		$TextureRect.texture = item.image
		value = item.value
		description = item.description
	
	
func setPos(pos):
	rect_position = pos
