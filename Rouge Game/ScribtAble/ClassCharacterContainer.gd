extends Resource

export(String) var name = "Missing No"
export(String) var klass = "NoClass"
export(String) var description = "Ups Something went wrong"


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

var momentum = 0
var skill_points = 0

export(int) var base_exp_to_level = 0 #Wie viel Exp pro level draufgeschlagen wird damit er aufleved
export(int) var deathExp = 0 #Wie viel Exp der Chracter gibt wenn man ihn besiegt mal Level

export(int) var base_max_health = 0
export(int) var base_strength = 0
export(int) var Base_Defence = 0
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

