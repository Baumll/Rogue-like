extends Resource

class_name Character

export(String) var klass = "NoClass"
export(String) var name = "NoClass"
export(String) var description = "Ups Something went wrong"

#Main stats
export(int) var level = 0
var experience_points = 0
var max_health = 0
var health = 0
var strength = 0
var defence = 0
var magic_defence = 0
var dexterity = 0
var magic = 0
var speed = 0

var crit_chance = 0
var crit_modifier = 0 #Wie viel schade meher ein Kriischer treffer macht 0 = 200%

#Temporary Stats
var momentum = 0
var skill_points = 0

export(int) var base_exp_to_level = 0 #Wie viel Exp pro level draufgeschlagen wird damit er aufleved
export(int) var death_exp = 0 #Wie viel Exp der Chracter gibt wenn man ihn besiegt mal Level

export(int) var base_max_health = 0
export(int) var base_strength = 0
export(int) var base_defence = 0
export(int) var base_magic_defence = 0
export(int) var base_dexterity = 0
export(int) var base_magic = 0
export(int) var base_speed = 0
export(int) var base_crit_chance = 0
export(int) var base_crit_modifier = 0

#hidden Prozentuale modifier stats:
var heal_procent = 0.0
var damge_procent = 0.0
var magic_defence_procent = 0
var protect_procent = 0.0
var max_health_procent = 0.0
var strength_procent = 0.0
var defence_procent = 0.0
var dexterity_procent = 0.0
var magic_procent = 0.0
var speed_procent = 0.0

export(Texture) var image = null
export(Texture) var icon = null

export(Array, Resource) var moves = []
export(Array, Resource) var equip = [null,null] #max quipp
#export(Array, Resource) var status = []
var status_list = []

#Hidden Stats
var fun = 1
var holy = 0


func load_stats(charLib):
	#Laden von einer Libery
	if typeof(charLib) == TYPE_DICTIONARY :
		base_max_health = charLib["Health"]
		base_strength = charLib["Strength"]
		base_defence = charLib["Defence"]
		base_magic_defence = charLib["Magic_Defence"]
		base_dexterity = charLib["Dexterity"]
		base_magic = charLib["Magic"]
		base_speed = charLib["Speed"]
		
		heal_procent = 0
		damge_procent = 0
		protect_procent = 0
		
		max_health = base_max_health
		strength = base_strength
		defence = base_defence
		magic_defence = base_magic_defence
		dexterity = base_dexterity
		magic = base_magic
		speed = base_speed
		
		health = charLib["Health"]
		
		
		name = charLib["Name"]
		description = charLib["Description"]
		klass = charLib["Class"]
		level = charLib["Level"]
		
		image = load(charLib["Image"])
		icon = load(charLib["Icon"])
		
		momentum = charLib["Momentum"]
		experience_points = charLib["Experience_Points"]
		skill_points = charLib["Skill_Points"]
		#charLib["position"] = 0
		
		print(charLib["Moves"])
		moves = []
		for i in charLib["Moves"]:
			moves.append(GlobalFunktions.get_move(i))
	
		equip = [null,null]
		if charLib["Equip"] != null:
			for i in range(len(charLib["Equip"])):
				equip[i] = GlobalFunktions.get_item(i)
		
		if charLib["Status"] != null:
			for i in range(len(charLib["Status"])):
				status_list.append(GlobalFunktions.get_status(charLib["Status"][i], charLib["Turns"][i]))
		
		#holy = charLib["Holy"]
		#fun = charLib["Fun"]
		
		calculate_all_stats()
	
	#Das alte Laden
	else:
		print(typeof(charLib))
		var path = charLib
		base_max_health = path.base_max_health
		base_strength = path.base_strength
		base_defence = path.base_defence
		base_magic_defence = path.base_magic_defence
		base_dexterity = path.base_dexterity
		base_magic = path.base_magic
		base_speed = path.base_speed
		
		heal_procent = path.heal_procent
		damge_procent = path.damge_procent
		protect_procent = path.protect_procent
		
		max_health = base_max_health
		strength = base_strength
		defence = base_defence
		dexterity = base_dexterity
		magic = base_magic
		speed = base_speed
		
		health = max_health
		
		name = path.name
		klass = path.klass
		description = path.description
		
		image = path.image
		icon = path.icon
		
		moves = path.moves
		equip = path.equip
		status_list = path.status_list
		
		holy = path.holy
		fun = path.fun
		
	calculate_all_stats()
	#else:
	#	print("Cant load Character")

func reset_stats():
	max_health = base_max_health
	strength = base_strength
	dexterity = base_dexterity
	defence = base_defence
	magic_defence = base_magic_defence
	magic = base_magic
	speed = base_speed
	heal_procent = 0
	damge_procent = 0
	max_health_procent = 0
	strength_procent = 0
	defence_procent = 0
	magic_procent = 0
	speed_procent = 0
	crit_chance = base_crit_chance
	crit_modifier = base_crit_modifier

func character_to_lib(pos):
	
	var lib = {}
	lib["max_health"] = base_max_health
	lib["Health"] = health
	lib["Strengh"] = base_strength
	lib["Base_Defence"] = base_defence
	lib["Magic_Defence"] = base_magic_defence
	lib["Dexterity"] = base_dexterity
	lib["Magic"] = base_magic
	lib["Speed"] = base_speed
	
	lib["Name"] = name
	lib["Class"] = klass
	lib["Level"] = level
	lib["Description"] = description
	
	lib["Image"] = image.resource_path
	lib["Icon"] = icon.resource_path
	
	#other stats:
	lib["Momentum"] = momentum
	lib["Experience_Points"] = experience_points
	lib["skill_points"] = skill_points
	lib["Position"] = pos
	
	lib["Moves"] = []
	for i in moves:
		if i != null:
			lib["Moves"].append(i.name)
		
	lib["Equip"] = []
	for i in equip:
		if i != null:
			lib["Equip"].append(i.name)
	
	lib["Status"] = []
	for i in status_list:
		if i != null:
			lib["Status"].append(i.name)
	
	#Die zeiten für die Status effekte
	lib["Turns"] = []
	for i in status_list:
		if i != null:
			lib["Turns"].append(i.turns)
	return lib

func calculate_all_stats():
	reset_stats()
	#for i in equip:
	#	if i != null:
	#		calculate_stats(i.status)
	
	#Nur für die Statusse
	var usedList = []
	for i in status_list:
		if i != null:
			if i.unique:
				if usedList.has(i):
					continue
				else:
					usedList.append(i)
			calculate_stats(i)
	

	
	max_health = (1+max_health_procent) * max_health
	strength = (1+strength_procent) * strength
	dexterity = (1+dexterity_procent) * dexterity
	defence = (1+defence_procent) * defence
	magic_defence = (1+magic_defence_procent) * magic_defence
	magic = (1+magic_procent) * magic
	speed = (1+speed_procent) * speed
	


func calculate_stats(status):
		max_health += status.max_health
		strength += status.strength
		dexterity += status.dexterity
		defence += status.defence
		magic_defence += status.magic_defence
		magic += status.magic
		speed += status.speed
		heal_procent += status.heal_procent
		damge_procent += status.damge_procent
		max_health_procent += status.max_health_procent
		strength_procent += status.strength_procent
		defence_procent += status.defence_procent
		magic_procent += status.magic_procent
		speed_procent += status.speed_procent
		crit_chance += status.crit_chance
		crit_modifier += status.crit_modifier

func iterate_status():
	var remove_list = []
	calculate_all_stats()
	for i in range(status_list.size()):
		if status_list[i] != null:
			if(status_list[i].turns > 1):
				status_list[i].turns -= 1
			if status_list[i].statusTyp == status_list[i].status_types.dmg:
				get_dmg(status_list[i].value)
			if status_list[i].statusTyp == status_list[i].status_types.heal:
				get_heal( status_list[i].value)
			if status_list[i].turns == 0:
				remove_list.append(i)
	for i in remove_list:
		status_list.remove(i)
		

func append_status(status):
	if status != null:
		for i in status_list:
			#Wenn unique und unendlich
			if i.name == status.name:
				if status.max_turns > 0:
					#Wenn endlich unique und vorhanden wird der wert zurrück gesetzt
					if i.turns < status.max_turns:
						i.turns = status.max_turns
					return
		#Unenldich und unique hinzugefügt
		status_list.append(status)
	calculate_all_stats()

func remove_status(status):
	if status != null:
		for i in status_list:
			#Hier der Fall für nicht einzigartige Staten
			if i.name == status.name:
				status_list.erase(i)
				break
	calculate_all_stats()

func remove_item(slot):
	if slot < equip.size():
		if equip[slot] != null:
			remove_status(equip[slot].status)
			equip[slot] = null

func add_item(slot,item):
	if slot < equip.size():
		equip[slot] = item
		if item.status != null:
			append_status(item.status)

#0 = physisch
#1 = magisch
#2 = heal
func get_dmg(amount):
	if(amount == 0):
		return null
	health -= amount
	return amount

func get_magic_dmg(amount):
	if(amount == 0):
		return null
	health -= amount
	return amount
	
func get_heal(amount):
	if(amount == 0):
		return null
	health += amount
	if health > max_health:
		health = max_health
	return amount

func reset_health():
	health = max_health

func give_exp(amount):
	experience_points += amount
	if experience_points > level*base_exp_to_level:
		experience_points -= level*base_exp_to_level
		level_up()

func level_up():
	skill_points += 2
	level += 1

func has_dealt_magic(amount):
	print(name + " has deald " + str(amount) + " magic dmg")


func has_dealt_physical(amount):
	print(name + " has deald " + str(amount) + " pyhrical dmg")


func has_healed(amount):
	print(name + " has deald " + str(amount) + " heald dmg")
