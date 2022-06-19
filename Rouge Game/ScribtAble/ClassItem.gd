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
export(int) var maxHealth = 5
export(int) var strength = 0
export(int) var defence = 0
export(int) var magicDefence = 0
export(int) var dexterity = 0
export(int) var magic = 0
export(int) var speed = 0
export(int) var critChance = 0
export(int) var critModifier = 0
export(float) var healProcent = 0.0
export(float) var damgeProcent = 0.0
export(float) var protectProcent = 0.0
export(float) var magicDefenceProcent = 0.0
export(float) var maxHealthProcent = 0.0
export(float) var strengthProcent = 0.0
export(float) var defenceProcent = 0.0
export(float) var dexterityProcent = 0.0
export(float) var magicProcent = 0.0
export(float) var speedProcent = 0.0




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
		
		maxHealth = item.maxHealth
		strength = item.strength
		defence = item.defence
		magicDefence = item.magicDefence
		dexterity = item.dexterity
		magic = item.magic
		speed = item.speed
		critChance = item.critChance
		critModifier = item.critModifier
		healProcent = item.healProcent
		damgeProcent = item.damgeProcent
		protectProcent = item.protectProcent
		magicDefenceProcent = item.magicDefenceProcent
		maxHealthProcent = item.maxHealthProcent
		strengthProcent = item.strengthProcent
		defenceProcent = item.defenceProcent
		dexterityProcent = item.dexterityProcent
		magicProcent = item.magicProcent
		speedProcent = item.speedProcent

		icon = item.icon
		status = item.status
"""
