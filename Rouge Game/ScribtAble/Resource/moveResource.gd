extends Resource

class_name Move

export(String) var name = "NoName"
export(String) var description = "Ein einfacher angriff ohne was"
export(int) var level = 1
export(Texture) var image = null
export(int) var cost = 10
export(int, LAYERS_2D_PHYSICS) var targets 
export(int) var physical_dmg = 0
export(int) var magical_dmg = 0
export(int) var heal = 0
export(Resource) var status
export(String) var animation #0 = Value oder status
export(AudioStream) var sound #0 = Value oder status

func get_targets(pos):
	#pos 0 = ganz links
	var pos_targets = (targets >> 8 * pos) & 0xff;
	var target_list = []
	for i in range(GlobalFunktions.team_size * 2):
		if (pos_targets >> i) & 0x1 == 1:
			target_list.append(i)
	#Wenn Leer wird ein zufäliiger gegner ausgewählt
	if target_list == []:
		target_list.append(GlobalFunktions.rng.randi_range(0,GlobalFunktions.team_size-1))
	if pos < GlobalFunktions.team_size:
		for target in target_list:
			target += GlobalFunktions.team_size
			target = target % (GlobalFunktions.team_size*2)
	return

#Damit man ein Move auch kopieren kann brauche ich für den Kampf
func load_move(source):
	if typeof(source) == TYPE_DICTIONARY:
		name = source["Name"]
		description = source["Description"]
		image = load(source["Image"])
		cost = source["Cost"]
		targets = source["Targets"]
		physical_dmg = source["Physical_Dmg"]
		magical_dmg = source["Magical_Dmg"]
		heal = source["Heal"]
		status = GlobalFunktions.get_status(source["Status"])
		animation = source["Animation"] #0 = Value oder status
		sound = null #load(source["Sound"]) #0 = Value oder status
	else:
		name = source.name
		description = source.description
		image = load(source.image)
		cost = source.cost
		targets = source.targets
		physical_dmg = source.physical_dmg
		magical_dmg = source.magical_dmg
		heal = source.heal
		status = source.status
		animation = source.animation #0 = Value oder status
		sound = null#source.sound #0 = Value oder status
