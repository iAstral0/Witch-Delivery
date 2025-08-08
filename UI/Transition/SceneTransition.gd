extends CanvasLayer

@onready var colorRect = $ColorRect
@onready var Animator = $AnimationPlayer
@onready var Audio = $Audio


func _ready():
	colorRect.visible = false

func LoadScene(_targetScene: String):
	colorRect.visible = true
	Animator.play("Diamond")
	await Animator.animation_finished
	get_tree().change_scene_to_file(_targetScene)
	Animator.play_backwards("Diamond")
	await Animator.animation_finished
	colorRect.visible = false

func ReloadScene():
	colorRect.visible = true
	Animator.play("Diamond")
	await Animator.animation_finished
	get_tree().reload_current_scene()
	Animator.play_backwards("Diamond")
	await Animator.animation_finished
	colorRect.visible = false

func QuitScene():
	colorRect.visible = true
	Animator.play("Diamond")
	await Animator.animation_finished
	get_tree().quit()
