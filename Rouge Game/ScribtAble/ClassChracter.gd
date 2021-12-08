extends Resource

class_name ClassChracter


export(String) var klass = "Mage"
var Level = 1
var maxHealth = 5
var health = 5
var streng = 0
var defence = 0
var dexterity = 0
var magic = 0
var speed = 5
var momentum = 0
var critChance = 0
var critModifier = 0 #Wie viel schade meher ein Kriischer treffer macht 0 = 200%

export(int) var baseMaxHealth = 5
export(int) var baseStreng = 0
export(int) var baseDefence = 0
export(int) var baseDexterity = 0
export(int) var baseMagic = 0
export(int) var baseSpeed = 5
export(int) var baseCritChance = 0
export(int) var baseCritModifier = 0

#hidden Prozentuale modifier stats:
var healProcent = 0.0
var damgeProcent = 0.0
var protectProcent = 0.0
var maxHealthProcent = 0.0
var strengProcent = 0.0
var defenceProcent = 0.0
var dexterityProcent = 0.0
var magicProcent = 0.0
var speedProcent = 0.0



export(Texture) var image = null
export(Texture) var icon = null

export(Array, Resource) var moves = []
export(Array, Resource) var equip = [null,null]
export(Array, Resource) var status = []

func reset_stats():
	maxHealth = baseMaxHealth
	streng = baseStreng
	dexterity = baseDexterity
	defence = baseDefence
	magic = baseMagic
	speed = baseSpeed
	healProcent = 0
	damgeProcent = 0
	maxHealthProcent = 0
	strengProcent = 0
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
	for i in status:
		if i != null:
			calculate_stats(i)
	maxHealth = (1+maxHealthProcent) * maxHealth
	streng = (1+strengProcent) * streng
	dexterity = (1+dexterityProcent) * dexterity
	defence = (1+defenceProcent) * defence
	magic = (1+magicProcent) * magic
	speed = (1+speedProcent) * speed
	

func calculate_stats(i):
		maxHealth += i.maxHealth
		streng += i.streng
		dexterity += i.dexterity
		defence += i.defence
		magic += i.magic
		speed += i.speed
		healProcent += i.healProcent
		damgeProcent += i.damgeProcent
		maxHealthProcent += i.maxHealthProcent
		strengProcent += i.strengProcent
		defenceProcent += i.defenceProcent
		magicProcent += i.magicProcent
		speedProcent += i.speedProcent
		critChance += i.critChance
		critModifier += i.critModifier

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

func get_dmg(amount) -> int:
	health -= amount
	return health
	
func get_heal(amount) -> int:
	health += amount
	if health > maxHealth:
		health = maxHealth
	return health
