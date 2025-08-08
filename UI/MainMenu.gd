extends Control

const gameScene = "res://Level/World.tscn"
@onready var highScore = $MarginContainer/Highscore
@onready var witchTheme = $Music/WitchTheme

func _ready():
	witchTheme.playing = true
	var highscore = SaveLoad.LoadScore()
	if str(highscore) != "0":
		highScore.visible = true
		highScore.text = "Highscore\n" + str(highscore)
	elif str(highscore) == "0":
		highScore.visible = false

func _on_start_pressed():
	SceneTransition.LoadScene(gameScene)

func _on_how_to_play_pressed():
	pass

func _on_quit_pressed():
	SceneTransition.QuitScene()
