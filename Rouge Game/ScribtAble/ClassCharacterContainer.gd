extends Resource

class_name ClassChracterStats

export(String) var name = "Missing No"
export(String) var klass = "NoClass"
export(String) var description = "Ups Something went wrong"


export(int) var level = 0
var experiencePoints = 0
var maxHealth = 0
var health = 0
var strength = 0
var defence = 0
var magicDefence = 0
var dexterity = 0
var magic = 0
var speed = 0

var critChance = 0
var critModifier = 0 #Wie viel schade meher ein Kriischer treffer macht 0 = 200%

var momentum = 0
var skillPoints = 0

export(int) var baseExpToLevel = 0 #Wie viel Exp pro level draufgeschlagen wird damit er aufleved
export(int) var deathExp = 0 #Wie viel Exp der Chracter gibt wenn man ihn besiegt mal Level

export(int) var baseMaxHealth = 0
export(int) var baseStrength = 0
export(int) var baseDefence = 0
export(int) var baseMagicDefence = 0
export(int) var baseDexterity = 0
export(int) var baseMagic = 0
export(int) var baseSpeed = 0
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
export(Array, Resource) var equip = []
#export(Array, Resource) var status = []
var statusList = []

