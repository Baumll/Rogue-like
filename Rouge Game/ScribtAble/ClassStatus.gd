extends Resource

#Keine ahnung ob ich das brauchte
class_name ClassStatus


enum status_types {buff, heal, dmg, combat}
export(status_types) var status_typ

export(StreamTexture) var icon = null
export(String) var name
export var unique = true
var turns = 0
export(int) var max_turns = 3
export(float) var value = 0.0

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
export(float) var magicDefence_procent = 0.0
export(float) var dexterity_procent = 0.0
export(float) var magic_procent = 0.0
export(float) var speed_procent = 0.0

export(String) var trigger_combat_start = null
export(String) var trigger_combat_end = null
export(String) var trigger_pre_move = null
export(String) var trigger_after_move = null
export(String) var trigger_pre_dmg = null
export(String) var trigger_after_dmg = null
