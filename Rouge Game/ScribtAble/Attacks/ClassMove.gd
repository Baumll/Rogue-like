extends Resource

class_name ClassMove

enum move_kinds {none, strike, buff, debuff, heal, poison}
enum target_kinds {inFront, adjacentEnemy, allEnemy, me, allTeamOther, allTeam, chooseEnemy, chooseFriend,  none }


export(String) var name = "self Damg"
export(String) var description = "Ein einfacher angriff ohne was"
export(Texture) var image = null
export(int) var cost = 10
export(target_kinds) var targets
export(Array, move_kinds) var moves 
export(Array) var value #0 = Value oder status
export(String) var animation #0 = Value oder status
export(AudioStream) var sound #0 = Value oder status
