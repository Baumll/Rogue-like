extends HBoxContainer

onready var rectList = [$TextureRect1, $TextureRect2, $TextureRect3, $TextureRect4, $TextureRect5, $TextureRect6, $TextureRect7]


func set_icon(tex, num):
	rectList[num].texture = tex
