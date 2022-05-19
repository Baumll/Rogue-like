extends Node


func loadStats(character, path):
	if typeof(path) == TYPE_STRING:
		path = load(path)
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
	
	character.klass = path.klass
	
	character.image = path.image
	character.icon = path.icon
	
	character.moves = path.moves
	character.equip = path.equip
	character.statusList = path.statusList



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



func calculate_all_stats(character):
	reset_stats(character)
	#for i in character.equip:
	#	if i != null:
	#		calculate_stats(character,i.status)
	for i in character.statusList:
		if i != null:
			if typeof(i) == TYPE_ARRAY:
				#Wenn unique und unendlich 
				calculate_stats(character,i[0])
			else:
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
		if status.unique == true:
			for i in character.statusList:
				#Wenn unique und unendlich
				#Wenn vorhanden
				if typeof(i) == TYPE_ARRAY:
					if i[0].name == status.name:
						i[1] += 1
						return
				if i.name == status.name:
					if status.maxTurns > 0:
						#Wenn endlich unique und vorhanden wird der wert zurrück gesetzt
						if i.turns < status.maxTurns:
							i.turns = status.maxTurns
						return
			#Unenldich und unique hinzugefügt
			character.statusList.append([status,1])
		else:
			#enldich hinzugefügt
			character.statusList.append(status)
	calculate_all_stats(character)

func remove_status(character, status):
	if status != null:
		for i in character.statusList:
			#Hier der Fall für nicht einzigartige Staten
			if typeof(i) == TYPE_ARRAY:
				#Unique und unenlich
				if i[0].name == status.name:
					i[1] -=1 
				if i[1] <= 0:
					character.statusList.erase(i)
					break
			else:
				if i.name == status.name:
					character.statusList.erase(i)
					break
	calculate_all_stats(character)

func remove_item(character, item):
	if item != null:
		remove_status(character, item.status)

func add_item(character, item):
	if item != null:
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
		character.skillPoints += 2
		character.level += 1

func has_dealt_magic(character,amount):
	pass

func has_dealt_physical(character,amount):
	pass

func has_healed(character,amount):
	pass
