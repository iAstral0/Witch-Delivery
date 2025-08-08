extends Node2D

@export_enum("Blue", "Green", "Yellow", "Orange") var witchType = 0
@onready var Animator = $AnimationPlayer

func _process(_delta):
	HandleAnimations()

func GetWitchTypeName()->String:
	match witchType:
		0:
			return "blue"
		1:
			return "green"
		2:
			return "yellow"
		3:
			return "orange"
		_:
			return ""

func _on_area_body_entered(body):
	if body is PlayerContoller:
		var interactManager = body.get_node("InteractionManager")
		interactManager.SetWitchArea(true, GetWitchTypeName())

func _on_area_body_exited(body):
	if body is PlayerContoller:
		var interactManager = body.get_node("InteractionManager")
		interactManager.SetWitchArea(false, GetWitchTypeName())

func HandleAnimations():
	Animator.play("Idle")
