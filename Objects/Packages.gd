extends Area2D

func _on_body_entered(body):
	if body is PlayerContoller:
		var interactManager = body.get_node("InteractionManager")
		interactManager.SetPackageArea(true)

func _on_body_exited(body):
	if body is PlayerContoller:
		var interactManager = body.get_node("InteractionManager")
		interactManager.SetPackageArea(false)
