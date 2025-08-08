extends Node2D

const mainMenu = "res://UI/MainMenu.tscn"

# Start Countdown
@onready var startCountdown = $UI/StartCountdown
@onready var startColor = $UI/StartCountdown/ColorRect
@onready var startAnimator = $UI/StartCountdown/AnimationPlayer
@onready var timedBar = $UI/TimedBar
@onready var progressBar = $UI/TimedBar/ProgressBar
@onready var game_Timer = $Time/GameTimer
@onready var player = $Player
@onready var scoreLabel = $UI/Label
@onready var endGame = $UI/EndGame
@onready var currentScore = $UI/EndGame/CenterContainer/VBoxContainer/HBoxContainer/CurrentScore
@onready var highScore = $UI/EndGame/CenterContainer/VBoxContainer/HBoxContainer/HighScore

# UI
@onready var backToMainMenu = $UI/EndGame/CenterContainer/VBoxContainer/BackToMainMenu
@onready var pauseMenu = $UI/PauseMenu

# SFX
@onready var countdownSFX = $SFX/Countdown
@onready var gameOverSFX = $SFX/GameOver

# Variables
@onready var gameTime: float = 60
@onready var currScore = 0 
@onready var shakeTimedBar = 0
var gamePaused = false

func _ready():
	HandleGameStart()
	UpdateScore()
	player.InteractManager.connect("PackageDelivered", Callable(self, "_onPackageDelivered"))

func _process(delta):
	HandleGameTime(delta)
	HandleGameEnd()

func HandleGameStart():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	progressBar.value = gameTime
	game_Timer.start(gameTime)
	get_tree().paused = true
	startCountdown.visible = true
	await SceneTransition.Animator.animation_finished
	startAnimator.play("startCountdown")
	countdownSFX.playing = true
	await startAnimator.animation_finished
	startCountdown.visible = false
	get_tree().paused = false

func HandleGameTime(delta):
	if game_Timer.time_left > 0:
		gameTime -= delta
		shakeTimedBar += delta / 100
		#print(shakeTimedBar)
		gameTime = max(gameTime, 0)
		progressBar.value = gameTime
		progressBar.material.set_shader_parameter("hit_effect", shakeTimedBar)
		#print(game_Timer.time_left)
				
	elif game_Timer.time_left < 0:
		game_Timer.stop()

func HandleGameEnd():
	if game_Timer.is_stopped():
		shakeTimedBar = 0
		progressBar.material.set_shader_parameter("hit_effect", shakeTimedBar)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		endGame.visible = true
		gameOverSFX.playing = true
		currentScore.text = "Score\n" + str(currScore)
		var highscore = SaveLoad.LoadScore()
		highScore.text = "Highscore\n" + str(highscore)
		if currScore > highscore:
			highscore = currScore
			SaveLoad.SaveHighScore(highscore)
			currentScore.text = "Score\n" + str(currScore)
			highScore.text = "Highscore\n" + str(highscore)
		get_tree().paused = true

func UpdateScore():
	scoreLabel.text = "Score\n" + str(currScore)

func AddScore(points: int):
	currScore += points
	UpdateScore()

func _onPackageDelivered():
	AddScore(1)

# Pause Menu
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		gamePaused = !gamePaused
		if gamePaused:
			get_tree().paused = true
			pauseMenu.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			get_tree().paused = false
			pauseMenu.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_resume_pressed():
	gamePaused = false
	get_tree().paused = false
	pauseMenu.visible = false

func _on_restart_pressed():
	SceneTransition.ReloadScene()

func _on_back_to_main_menu_pressed():
	SceneTransition.LoadScene(mainMenu)

# End Game
func _on_button_pressed():
	SceneTransition.LoadScene(mainMenu)

func _on_play_again_pressed():
	SceneTransition.ReloadScene()

