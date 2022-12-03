extends Node

enum status_types {buff, heal, dmg, combat}
export(status_types) var status_type

export(StreamTexture) var icon = null
export var unique = true
var turns = 0
export(int) var max_turns = 3 #-1 = Infinit

export(int) var max_health = 0
export(int) var strength = 0
export(int) var defence = 0
export(int) var magic_defence = 0
export(int) var dexterity = 0
export(int) var magic = 0
export(int) var speed = 0
export(int) var crit_chance = 0
export(int) var crit_modifier = 0 #Wie viel schade meher ein Kriischer treffer macht 0 = 200%

#hidden Prozentuale modifier stats:
export(float) var heal_procent = 0.0
export(float) var damge_procent = 0.0
export(float) var protect_procent = 0.0
export(float) var max_health_procent = 0.0
export(float) var strength_procent = 0.0
export(float) var defence_procent = 0.0
export(float) var magic_defence_procent = 0.0
export(float) var dexterity_procent = 0.0
export(float) var magic_procent = 0.0
export(float) var speed_procent = 0.0

export(String) var trigger_combat_start = null
export(String) var trigger_combat_end = null
export(String) var trigger_pre_move = null
export(String) var trigger_after_move = null
export(String) var trigger_pre_dmg = null
export(String) var trigger_after_dmg = null


func load_status(data):
	if typeof(data) == TYPE_DICTIONARY:
		status_type = data["Type"]
		if data["Icon"] != null:
			icon = load(data["Icon"])
		unique = data["Unique"]
		turns = data["Turns"]
		max_turns = data["Max_Turns"]
		max_health = data["Max_Health"]
		strength = data["Strength"]
		defence = data["Defence"]
		magic_defence = data["Magic_Defence"]
		dexterity = data["Dexterity"]
		magic = data["Magic"]
		speed = data["Speed"]
		crit_chance = data["Crit_Chance"]
		crit_modifier = data["Crit_Modifier"]
		heal_procent = data["Heal_Procent"]
		damge_procent = data["Damage_Procent"]
		protect_procent = data["Protect_Procent"]
		max_health_procent = data["Max_Health_Procent"]
		strength_procent = data["Strength_Procent"]
		defence_procent = data["Defence_Procent"]
		magic_defence_procent = data["Magic_Defence_Procent"]
		dexterity_procent = data["Dexterity_Procent"]
		magic_procent = data["Magic_Procent"]
		speed_procent = data["Speed_Procent"]

	else:
		print("Cant load item")
