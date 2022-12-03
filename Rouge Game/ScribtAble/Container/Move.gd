extends Node

enum target_kinds {in_front, adjacent_enemy, all_enemy, me, all_team_other, all_team, choose_enemy, choose_friend,  none }


export(String) var description = "Ein einfacher angriff ohne was"
export(Texture) var image = null
export(int) var cost = 10
export(target_kinds) var targets = target_kinds.in_front
export(int) var physical_dmg = 0
export(int) var magical_dmg = 0
export(int) var heal = 0
export(Resource) var status
export(String) var animation #0 = Value oder status
export(AudioStream) var sound #0 = Value oder status


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
