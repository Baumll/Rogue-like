extends Resource

class_name ClassChracter

export(String) var klass = "Mage"
export(int) var level = 1
var experiencePoints = 0
var maxHealth = 5
var health = 5
var strength = 0
var defence = 0
var magicDefence = 0
var dexterity = 0
var magic = 0
var speed = 5
var momentum = 0
var critChance = 0
var critModifier = 0 #Wie viel schade meher ein Kriischer treffer macht 0 = 200%
export(int) var baseExpToLevel = 20 #Wie viel Exp pro level draufgeschlagen wird damit er aufleved
export(int) var deathExp = 5 #Wie viel Exp der Chracter gibt wenn man ihn besiegt mal Level

export(int) var baseMaxHealth = 5
export(int) var baseStrength = 0
export(int) var baseDefence = 0
export(int) var baseMagicDefence = 0
export(int) var baseDexterity = 0
export(int) var baseMagic = 0
export(int) var baseSpeed = 5
export(int) var baseCritChance = 0
export(int) var baseCritModifier = 0

#hidden Prozentuale modifier stats:
var healProcent = 0.0
var damgeProcent = 0.0
var magicDefenceProcent = 0
var protectProcent = 0.0
var maxHealthProcent = 0.0
var strengthProcent = 0.0
var defenceProcent = 0.0
var dexterityProcent = 0.0
var magicProcent = 0.0
var speedProcent = 0.0



export(Texture) var image = null
export(Texture) var icon = null

export(Array, Resource) var moves = []
export(Array, Resource) var equip = [null,null]
#export(Array, Resource) var status = []
var statusList = []

func loadStats(path):
	var item = load(path)
	baseMaxHealth = item.baseMaxHealth
	baseStrength = item.baseStrength
	baseDefence = item.baseDefence
	baseMagicDefence = item.baseMagicDefence
	baseDexterity = item.baseDexterity
	baseMagic = item.baseMagic
	baseSpeed = item.baseSpeed
	
	healProcent = item.healProcent
	damgeProcent = item.damgeProcent
	protectProcent = item.protectProcent
	
	maxHealth = baseMaxHealth
	strength = baseStrength
	defence = baseDefence
	dexterity = baseDexterity
	magic = baseMagic
	speed = baseSpeed
	
	health = maxHealth
	
	klass = item.klass
	
	image = item.image
	icon = item.icon
	
	moves = item.moves
	equip = item.equip



func reset_stats():
	maxHealth = baseMaxHealth
	strength = baseStrength
	dexterity = baseDexterity
	defence = baseDefence
	magicDefence = baseMagicDefence
	magic = baseMagic
	speed = baseSpeed
	healProcent = 0
	damgeProcent = 0
	maxHealthProcent = 0
	strengthProcent = 0
	defenceProcent = 0
	magicProcent = 0
	speedProcent = 0
	critChance = baseCritChance
	critModifier = baseCritModifier



func calculate_all_stats():
	reset_stats()
	for i in equip:
		if i != null:
			calculate_stats(i)
	for i in statusList:
		if i != null:
			calculate_stats(i)
	maxHealth = (1+maxHealthProcent) * maxHealth
	strength = (1+strengthProcent) * strength
	dexterity = (1+dexterityProcent) * dexterity
	defence = (1+defenceProcent) * defence
	magicDefence = (1+magicDefenceProcent) * magicDefence
	magic = (1+magicProcent) * magic
	speed = (1+speedProcent) * speed
	


func calculate_stats(i):
		maxHealth += i.maxHealth
		strength += i.strength
		dexterity += i.dexterity
		defence += i.defence
		magicDefence += i.magicDefence
		magic += i.magic
		speed += i.speed
		healProcent += i.healProcent
		damgeProcent += i.damgeProcent
		maxHealthProcent += i.maxHealthProcent
		strengthProcent += i.strengthProcent
		defenceProcent += i.defenceProcent
		magicProcent += i.magicProcent
		speedProcent += i.speedProcent
		critChance += i.critChance
		critModifier += i.critModifier

func iterate_status():
	var removeList = []
	calculate_all_stats()
	for i in range(statusList.size()):
		if statusList[i] != null:
			statusList[i].turns -= 1
			if statusList[i].statusTyp == statusList[i].statusTypes.dmg:
				get_dmg(statusList[i].value)
			if statusList[i].statusTyp == statusList[i].statusTypes.heal:
				get_heal(statusList[i].value)
			if statusList[i].turns <= 0:
				removeList.append(i)
	for i in removeList:
		statusList.remove(i)
		

func append_status(status):
	for i in statusList:
		if i.name == status.name:
			if i.turns < status.maxTurns:
				i.turns = status.maxTurns
			return
	statusList.append(status)
	
"""
old
func iterate_status():
	var removeList = []
	calculate_all_stats()
	for i in range(status.size()):
		status[i].turns -= 1
		if status.statusTyp == status.statusTypes.dmg:
			get_dmg(status.value)
		if status.statusTyp == status.statusTypes.heal:
			get_heal(status.value)
		if status[i].turns <= 0:
			removeList.append(i)
	for i in removeList:
		status.remove(i)
"""
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
		level += 1

func has_dealt_magic(amount):
	pass

func has_dealt_physical(amount):
	pass

func has_healed(amount):
	pass
