extends Node

func new_character(data = null):
	var preChar = load("res://ScribtAble/ClassCharacterContainer.gd")
	var character = preChar.new()
	if data != null:
		loadStats(character, data)
	
	return character

func loadStats(character, charLib):
	
	#Laden von einer Libery
	if typeof(charLib) == TYPE_DICTIONARY :
		character.base_max_health = charLib["Health"]
		character.base_strength = charLib["Strengh"]
		character.base_defence = charLib["Base_Defence"]
		character.base_magic_defence = charLib["Magic_Defence"]
		character.base_dexterity = charLib["Dexterity"]
		character.base_magic = charLib["Magic"]
		character.base_speed = charLib["Speed"]
		
		character.heal_procent = 0
		character.damge_procent = 0
		character.protect_procent = 0
		
		character.max_health = character.base_max_health
		character.strength = character.base_strength
		character.defence = character.base_defence
		character.dexterity = character.base_dexterity
		character.magic = character.base_magic
		character.speed = character.base_speed
		
		character.health = character.max_health
		
		
		character.name = charLib["Name"]
		character.description = charLib["Description"]
		character.klass = charLib["Class"]
		character.level = charLib["Level"]
		
		character.image = load(charLib["Image"])
		character.icon = load(charLib["Icon"])
		
		character.momentum = charLib["Momentum"]
		character.experience_points = charLib["experience_points"]
		character.skill_points = charLib["skill_points"]
		#charLib["position"] = 0
		
		print(charLib["Moves"])
		character.moves = []
		for i in charLib["Moves"]:
			character.moves.append(load(i))
	
		character.equip = []
		for i in charLib["Equip"]:
			character.equip.append(load(i))
		
		for i in charLib["Status"]:
			character.status_list.append(load(i))
			
		calculate_all_stats(character)
	
	#Das alte Laden
	
	else:
		var path = charLib
		character.base_max_health = path.base_max_health
		character.base_strength = path.base_strength
		character.base_defence = path.base_defence
		character.base_magic_defence = path.base_magic_defence
		character.base_dexterity = path.base_dexterity
		character.base_magic = path.base_magic
		character.base_speed = path.base_speed
		
		character.heal_procent = path.heal_procent
		character.damge_procent = path.damge_procent
		character.protect_procent = path.protect_procent
		
		character.max_health = character.base_max_health
		character.strength = character.base_strength
		character.defence = character.base_defence
		character.dexterity = character.base_dexterity
		character.magic = character.base_magic
		character.speed = character.base_speed
		
		character.health = character.max_health
		
		character.name = path.name
		character.klass = path.klass
		character.description = path.description
		
		character.image = load(path.image)
		character.icon = load(path.icon)
		
		character.moves = []
		for i in path.moves:
			character.moves.append(load(i))
			
		character.equip = []
		for i in path.equip:
			character.equip.append(load(i))
			
		character.status_list = []
		for i in path.status_list:
			character.status_list.append(load(i))
		calculate_all_stats(character)
	#else:
	#	print("Cant load Character")

func reset_stats(character):
	character.max_health = character.base_max_health
	character.strength = character.base_strength
	character.dexterity = character.base_dexterity
	character.defence = character.base_defence
	character.magic_defence = character.base_magic_defence
	character.magic = character.base_magic
	character.speed = character.base_speed
	character.heal_procent = 0
	character.damge_procent = 0
	character.max_health_procent = 0
	character.strength_procent = 0
	character.defence_procent = 0
	character.magic_procent = 0
	character.speed_procent = 0
	character.crit_chance = character.base_crit_chance
	character.crit_modifier = character.base_crit_modifier

func character_to_lib(character, pos):
	var lib = {}
	lib["max_health"] = character.base_max_health
	lib["Health"] = character.health
	lib["Strengh"] = character.base_strength
	lib["Base_Defence"] = character.base_defence
	lib["Magic_Defence"] = character.base_magic_defence
	lib["Dexterity"] = character.base_dexterity
	lib["Magic"] = character.base_magic
	lib["Speed"] = character.base_speed
	
	lib["Name"] = character.name
	lib["Class"] = character.klass
	lib["Level"] = character.level
	lib["Description"] = character.description
	
	
	lib["Image"] = character.image
	lib["Icon"] = character.icon
	
	#other stats:
	lib["Momentum"] = character.momentum
	lib["experience_points"] = character.experience_points
	lib["skill_points"] = character.skill_points
	lib["Position"] = pos
	
	
	lib["Moves"] = []
	for i in character.moves:
		if i != null:
			lib["Moves"].append(i)
		
	lib["Equip"] = []
	for i in character.equip:
		if i != null:
			lib["Equip"].append(i.to_dictonary())
	
	lib["Status"] = []
	for i in character.status_list:
		if i != null:
			lib["Status"].append(i)
	
	return lib

func calculate_all_stats(character):
	reset_stats(character)
	#for i in character.equip:
	#	if i != null:
	#		calculate_stats(character,i.status)
	
	#Nur für die Statusse
	var usedList = []
	for i in character.status_list:
		if i != null:
			if i.unique:
				if usedList.has(i):
					continue
				else:
					usedList.append(i)
			calculate_stats(character,i)
	

	
	character.max_health = (1+character.max_health_procent) * character.max_health
	character.strength = (1+character.strength_procent) * character.strength
	character.dexterity = (1+character.dexterity_procent) * character.dexterity
	character.defence = (1+character.defence_procent) * character.defence
	character.magic_defence = (1+character.magic_defence_procent) * character.magic_defence
	character.magic = (1+character.magic_procent) * character.magic
	character.speed = (1+character.speed_procent) * character.speed
	


func calculate_stats(character, status):
		character.max_health += status.max_health
		character.strength += status.strength
		character.dexterity += status.dexterity
		character.defence += status.defence
		character.magic_defence += status.magic_defence
		character.magic += status.magic
		character.speed += status.speed
		character.heal_procent += status.heal_procent
		character.damge_procent += status.damge_procent
		character.max_health_procent += status.max_health_procent
		character.strength_procent += status.strength_procent
		character.defence_procent += status.defence_procent
		character.magic_procent += status.magic_procent
		character.speed_procent += status.speed_procent
		character.crit_chance += status.crit_chance
		character.crit_modifier += status.crit_modifier

func iterate_status(character):
	var remove_list = []
	calculate_all_stats(character)
	for i in range(character.status_list.size()):
		if character.status_list[i] != null:
			if(character.status_list[i].turns > 1):
				character.status_list[i].turns -= 1
			if character.status_list[i].statusTyp == character.status_list[i].status_types.dmg:
				get_dmg(character, character.status_list[i].value)
			if character.status_list[i].statusTyp == character.status_list[i].status_types.heal:
				get_heal(character, character.status_list[i].value)
			if character.status_list[i].turns == 0:
				remove_list.append(i)
	for i in remove_list:
		character.status_list.remove(i)
		

func append_status(character, status):
	if status != null:
		for i in character.status_list:
			#Wenn unique und unendlich
			if i.name == status.name:
				if status.maxTurns > 0:
					#Wenn endlich unique und vorhanden wird der wert zurrück gesetzt
					if i.turns < status.maxTurns:
						i.turns = status.maxTurns
					return
		#Unenldich und unique hinzugefügt
		character.status_list.append(status)
	calculate_all_stats(character)

func remove_status(character, status):
	if status != null:
		for i in character.status_list:
			#Hier der Fall für nicht einzigartige Staten
			if i.name == status.name:
				character.status_list.erase(i)
				break
	calculate_all_stats(character)

func remove_item(character, slot):
	if slot < character.equip.size():
		if character.equip[slot] != null:
			remove_status(character, load(character.equip[slot].status))
			character.equip[slot] = null

func add_item(character, slot, item):
	if slot < character.equip.size():
		character.equip[slot] = item
		if item.status != null:
			append_status(character, load(item.status))
		
	

#0 = physisch
#1 = magisch
#2 = heal
func get_dmg(character, amount):
	if(amount == 0):
		return null
	character.health -= amount
	return amount

func get_magic_dmg(character, amount):
	if(amount == 0):
		return null
	character.health -= amount
	return amount
	
func get_heal(character, amount):
	if(amount == 0):
		return null
	character.health += amount
	if character.health > character.max_health:
		character.health = character.max_health
	return amount

func reset_health(character):
	character.health = character.max_health

func give_exp(character, amount):
	character.experience_points += amount
	if character.experience_points > character.level*character.base_exp_to_level:
		character.experience_points -= character.level*character.base_exp_to_level
		level_up(character)

func level_up(character):
	character.skill_points += 2
	character.level += 1

func has_dealt_magic(character,amount):
	pass

func has_dealt_physical(character,amount):
	pass

func has_healed(character,amount):
	pass
