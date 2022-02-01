extends Resource

#Keine ahnung ob ich das brauchte
class_name ClassStatus


enum statusTypes {buff, heal, dmg, combat}
export(statusTypes) var statusTyp

export(StreamTexture) var icon = null
export(String) var name
var turns = 0
export(int) var maxTurns = 3
export(float) var value = 0.0

export(int) var maxHealth = 0
export(int) var strength = 0
export(int) var defence = 0
export(int) var magicDefence = 0
export(int) var dexterity = 0
export(int) var magic = 0
export(int) var speed = 0
export(int) var critChance = 0
export(int) var critModifier = 0 #Wie viel schade meher ein Kriischer treffer macht 0 = 200%
#hidden Prozentuale modifier stats:
export(float) var healProcent = 0.0
export(float) var damgeProcent = 0.0
export(float) var protectProcent = 0.0
export(float) var maxHealthProcent = 0.0
export(float) var strengthProcent = 0.0
export(float) var defenceProcent = 0.0
export(float) var magicDefenceProcent = 0.0
export(float) var dexterityProcent = 0.0
export(float) var magicProcent = 0.0
export(float) var speedProcent = 0.0

export(String) var combatStartTrigger = null
export(String) var combatEndTrigger = null
export(String) var preMove = null
export(String) var afterMove = null
