extends Resource

class_name ClassItem

var rng = RandomNumberGenerator.new()
var source

export(String) var name = "Dagger"
export(String) var description = ""
export(StreamTexture) var icon = null
export(int) var value = 10
export(Resource) var status = null

"""
export(int) var max_health = 5
export(int) var strength = 0
export(int) var defence = 0
export(int) var magic_defence = 0
export(int) var dexterity = 0
export(int) var magic = 0
export(int) var speed = 0
export(int) var crit_chance = 0
export(int) var crit_modifier = 0
export(float) var heal_procent = 0.0
export(float) var damge_procent = 0.0
export(float) var protect_procent = 0.0
export(float) var magic_defence_procent = 0.0
export(float) var max_health_procent = 0.0
export(float) var strength_procent = 0.0
export(float) var defence_procent = 0.0
export(float) var dexterity_procent = 0.0
export(float) var magic_procent = 0.0
export(float) var speed_procent = 0.0




func _ready():
	rng.randomize()
	
	var ran = rng.randi_range(0,2)
	match ran:
		0:
			load_item("res://Units/Items/ItemDagger.tres")
			continue
		1:
			load_item("res://Units/Items/ItemHammer.tres")
			continue
		2:
			load_item("res://Units/Items/ItemBook.tres")
			continue
	

func load_item(path):
	if path != "" and path != null:
		var item = load(path)
		name = item.name
		description = item.description
		value = item.value
		
		max_health = item.max_health
		strength = item.strength
		defence = item.defence
		magic_defence = item.magic_defence
		dexterity = item.dexterity
		magic = item.magic
		speed = item.speed
		crit_chance = item.crit_chance
		crit_modifier = item.crit_modifier
		heal_procent = item.heal_procent
		damge_procent = item.damge_procent
		protect_procent = item.protect_procent
		magic_defence_procent = item.magic_defence_procent
		max_health_procent = item.max_health_procent
		strength_procent = item.strength_procent
		defence_procent = item.defence_procent
		dexterity_procent = item.dexterity_procent
		magic_procent = item.magic_procent
		speed_procent = item.speed_procent

		icon = item.icon
		status = item.status
"""
