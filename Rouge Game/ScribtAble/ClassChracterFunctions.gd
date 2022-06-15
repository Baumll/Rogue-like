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
		character.baseMaxHealth = charLib["Health"]
		character.baseStrength = charLib["Strengh"]
		character.baseDefence = charLib["BaseDefence"]
		character.baseMagicDefence = charLib["Magic_Defence"]
		character.baseDexterity = charLib["Dexterity"]
		character.baseMagic = charLib["Magic"]
		character.baseSpeed = charLib["Speed"]
		
		character.healProcent = 0
		character.damgeProcent = 0
		character.protectProcent = 0
		
		character.maxHealth = character.baseMaxHealth
		character.strength = character.baseStrength
		character.defence = character.baseDefence
		character.dexterity = character.baseDexterity
		character.magic = character.baseMagic
		character.speed = character.baseSpeed
		
		character.health = character.maxHealth
		
		
		character.name = charLib["Name"]
		character.description = charLib["Description"]
		character.klass = charLib["Class"]
		character.level = charLib["Level"]
		
		character.image = load(charLib["Image"])
		character.icon = load(charLib["Icon"])
		
		character.momentum = charLib["Momentum"]
		character.experiencePoints = charLib["ExperiencePoints"]
		character.skillPoints = charLib["SkillPoints"]
		#charLib["position"] = 0
		
		print(charLib["Moves"])
		character.moves = []
		for i in charLib["Moves"]:
			character.moves.append(load(i))
	
		character.equip = []
		for i in charLib["Equip"]:
			character.equip.append(load(i))
		
		for i in charLib["Status"]:
			character.statusList.append(load(i))
			
		calculate_all_stats(character)
	
	#Das alte Laden
	
	else:
		print(typeof(charLib))
		var path = charLib
		character.baseMaxHealth = path.baseMaxHealth
		character.baseStrength = path.baseStrength
		character.baseDefence = path.baseDefence
		character.baseMagicDefence = path.baseMagicDefence
		character.baseDexterity = path.baseDexterity
		character.baseMagic = path.baseMagic
		character.baseSpeed = path.baseSpeed
		
		character.healProcent = path.healProcent
		character.damgeProcent = path.damgeProcent
		character.protectProcent = path.protectProcent
		
		character.maxHealth = character.baseMaxHealth
		character.strength = character.baseStrength
		character.defence = character.baseDefence
		character.dexterity = character.baseDexterity
		character.magic = character.baseMagic
		character.speed = character.baseSpeed
		
		character.health = character.maxHealth
		
		character.name = path.name
		character.klass = path.klass
		character.description = path.description
		
		character.image = path.image
		character.icon = path.icon
		
		character.moves = path.moves
		character.equip = path.equip
		character.statusList = path.statusList
		
		calculate_all_stats(character)
	#else:
	#	print("Cant load Character")

func reset_stats(character):
	character.maxHealth = character.baseMaxHealth
	character.strength = character.baseStrength
	character.dexterity = character.baseDexterity
	character.defence = character.baseDefence
	character.magicDefence = character.baseMagicDefence
	character.magic = character.baseMagic
	character.speed = character.baseSpeed
	character.healProcent = 0
	character.damgeProcent = 0
	character.maxHealthProcent = 0
	character.strengthProcent = 0
	character.defenceProcent = 0
	character.magicProcent = 0
	character.speedProcent = 0
	character.critChance = character.baseCritChance
	character.critModifier = character.baseCritModifier

func character_to_lib(character, pos):
	var lib = {}
	lib["MaxHealth"] = character.baseMaxHealth
	lib["Health"] = character.health
	lib["Strengh"] = character.baseStrength
	lib["BaseDefence"] = character.baseDefence
	lib["Magic_Defence"] = character.baseMagicDefence
	lib["Dexterity"] = character.baseDexterity
	lib["Magic"] = character.baseMagic
	lib["Speed"] = character.baseSpeed
	
	lib["Name"] = character.name
	lib["Class"] = character.klass
	lib["Level"] = character.level
	lib["Description"] = character.description
	
	
	lib["Image"] = character.image.resource_path
	lib["Icon"] = character.icon.resource_path
	
	#other stats:
	lib["Momentum"] = character.momentum
	lib["ExperiencePoints"] = character.experiencePoints
	lib["SkillPoints"] = character.skillPoints
	lib["Position"] = pos
	
	
	lib["Moves"] = []
	for i in character.moves:
		if i != null:
			lib["Moves"].append(i.resource_path)
		
	lib["Equip"] = []
	var eq = []
	for i in character.equip:
		if i != null:
			lib["Equip"].append(i.resource_path)
			eq.append(i.resource_path)
	
	lib["Status"] = []
	for i in character.statusList:
		if i != null:
			lib["Status"].append(i.resource_path)
	
	return lib

func calculate_all_stats(character):
	reset_stats(character)
	#for i in character.equip:
	#	if i != null:
	#		calculate_stats(character,i.status)
	
	#Nur für die Statusse
	var usedList = []
	for i in character.statusList:
		if i != null:
			if i.unique:
				if usedList.has(i):
					continue
				else:
					usedList.append(i)
			calculate_stats(character,i)
	

	
	character.maxHealth = (1+character.maxHealthProcent) * character.maxHealth
	character.strength = (1+character.strengthProcent) * character.strength
	character.dexterity = (1+character.dexterityProcent) * character.dexterity
	character.defence = (1+character.defenceProcent) * character.defence
	character.magicDefence = (1+character.magicDefenceProcent) * character.magicDefence
	character.magic = (1+character.magicProcent) * character.magic
	character.speed = (1+character.speedProcent) * character.speed
	


func calculate_stats(character, status):
		character.maxHealth += status.maxHealth
		character.strength += status.strength
		character.dexterity += status.dexterity
		character.defence += status.defence
		character.magicDefence += status.magicDefence
		character.magic += status.magic
		character.speed += status.speed
		character.healProcent += status.healProcent
		character.damgeProcent += status.damgeProcent
		character.maxHealthProcent += status.maxHealthProcent
		character.strengthProcent += status.strengthProcent
		character.defenceProcent += status.defenceProcent
		character.magicProcent += status.magicProcent
		character.speedProcent += status.speedProcent
		character.critChance += status.critChance
		character.critModifier += status.critModifier

func iterate_status(character):
	var removeList = []
	calculate_all_stats(character)
	for i in range(character.statusList.size()):
		if character.statusList[i] != null:
			if(character.statusList[i].turns > 1):
				character.statusList[i].turns -= 1
			if character.statusList[i].statusTyp == character.statusList[i].statusTypes.dmg:
				get_dmg(character, character.statusList[i].value)
			if character.statusList[i].statusTyp == character.statusList[i].statusTypes.heal:
				get_heal(character, character.statusList[i].value)
			if character.statusList[i].turns == 0:
				removeList.append(i)
	for i in removeList:
		character.statusList.remove(i)
		

func append_status(character, status):
	if status != null:
		for i in character.statusList:
			#Wenn unique und unendlich
			if i.name == status.name:
				if status.maxTurns > 0:
					#Wenn endlich unique und vorhanden wird der wert zurrück gesetzt
					if i.turns < status.maxTurns:
						i.turns = status.maxTurns
					return
		#Unenldich und unique hinzugefügt
		character.statusList.append(status)
	calculate_all_stats(character)

func remove_status(character, status):
	if status != null:
		for i in character.statusList:
			#Hier der Fall für nicht einzigartige Staten
			if i.name == status.name:
				character.statusList.erase(i)
				break
	calculate_all_stats(character)

func remove_item(character, slot):
	if slot < character.equip.size():
		if character.equip[slot] != null:
			remove_status(character, character.equip[slot].status)
			character.equip[slot] = null

func add_item(character, slot, item):
	if slot < character.equip.size():
		character.equip[slot] = item
		if item.status != null:
			append_status(character, item.status)
		
	

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
	if character.health > character.maxHealth:
		character.health = character.maxHealth
	return amount

func reset_health(character):
	character.health = character.maxHealth

func give_exp(character, amount):
	character.experiencePoints += amount
	if character.experiencePoints > character.level*character.baseExpToLevel:
		character.experiencePoints -= character.level*character.baseExpToLevel
		level_up(character)

func level_up(character):
	character.skillPoints += 2
	character.level += 1

func has_dealt_magic(character,amount):
	pass

func has_dealt_physical(character,amount):
	pass

func has_healed(character,amount):
	pass
