extends Resource

class_name ClassMove

enum target_kinds {inFront, adjacentEnemy, allEnemy, me, allTeamOther, allTeam, chooseEnemy, chooseFriend,  none }


export(String) var name = "self Damg"
export(String) var description = "Ein einfacher angriff ohne was"
export(Texture) var image = null
export(int) var cost = 10
export(target_kinds) var targets = target_kinds.inFront
export(int) var physicalDmg = 0
export(int) var magicalDmg = 0
export(int) var heal = 0
export(Resource) var status
export(String) var animation #0 = Value oder status
export(AudioStream) var sound #0 = Value oder status


#Damit man ein Move auch kopieren kann brauche ich für den Kampf
func load_move(source):
	name = source.name
	description = source.description
	image = source.image
	cost = source.cost
	targets = source.targets
	physicalDmg = source.physicalDmg
	magicalDmg = source.magicalDmg
	heal = source.heal
	status = source.status
	animation = source.animation #0 = Value oder status
	sound = source.sound #0 = Value oder status
