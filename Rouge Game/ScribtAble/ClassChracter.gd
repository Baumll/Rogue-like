extends Node


func loadStats(path, character):
	var item
	if typeof(path) == TYPE_STRING:
		item = load(path)
	else:
		item = path
	character.baseMaxHealth = item.baseMaxHealth
	character.baseStrength = item.baseStrength
	character.baseDefence = item.baseDefence
	character.baseMagicDefence = item.baseMagicDefence
	character.baseDexterity = item.baseDexterity
	character.baseMagic = item.baseMagic
	character.baseSpeed = item.baseSpeed
	
	character.healProcent = item.healProcent
	character.damgeProcent = item.damgeProcent
	character.protectProcent = item.protectProcent
	
	character.maxHealth = character.baseMaxHealth
	character.strength = character.baseStrength
	character.defence = character.baseDefence
	character.dexterity = character.baseDexterity
	character.magic = character.baseMagic
	character.speed = character.baseSpeed
	
	character.health = character.maxHealth
	
	character.klass = character.item.klass
	
	character.image = character.item.image
	character.icon = character.item.icon
	
	character.moves = character.item.moves
	character.equip = character.item.equip
	character.statusList = character.item.statusList



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
	for i in character.equip:
		if i != null:
			calculate_stats(i,character)
	for i in character.statusList:
		if i != null:
			calculate_stats(i,character)
	character.maxHealth = (1+character.maxHealthProcent) * character.maxHealth
	character.strength = (1+character.strengthProcent) * character.strength
	character.dexterity = (1+character.dexterityProcent) * character.dexterity
	character.defence = (1+character.defenceProcent) * character.defence
	character.magicDefence = (1+character.magicDefenceProcent) * character.magicDefence
	character.magic = (1+character.magicProcent) * character.magic
	character.speed = (1+character.speedProcent) * character.speed
	


func calculate_stats(status,character):
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
			if(statusList[i].turns > 1):
				statusList[i].turns -= 1
			if statusList[i].statusTyp == statusList[i].statusTypes.dmg:
				get_dmg(statusList[i].value)
			if statusList[i].statusTyp == statusList[i].statusTypes.heal:
				get_heal(statusList[i].value)
			if statusList[i].turns == 0:
				removeList.append(i)
	for i in removeList:
		statusList.remove(i)
		

func append_status(status):
	if status != null:
		for i in statusList:
			if i.name == status.name:
				if i.turns < status.maxTurns:
					i.turns = status.maxTurns
				return
		statusList.append(status)

func remove_status(status):
	if status != null:
		for i in range(statusList.size()):
			if statusList[i].name == status.name:
				statusList.remove(i)

func remove_item(item):
	if item != null:
		remove_status(item.status)

func add_item(item):
	if item != null:
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
	if health > maxHealth:
		health = maxHealth
	return amount

func give_exp(amount):
	experiencePoints += amount
	if experiencePoints > level*baseExpToLevel:
		experiencePoints -= level*baseExpToLevel
		skillPoints += 2
		level += 1

func has_dealt_magic(amount):
	pass

func has_dealt_physical(amount):
	pass

func has_healed(amount):
	pass
