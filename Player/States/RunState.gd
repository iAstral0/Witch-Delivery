extends PlayerState

func EnterState():
	stateName = "Run"

func ExitState():
	pass

func Draw():
	pass

func Update(_delta):
	Player.HorizontalMov()
	Player.HandleJumps()
	Player.HandleFalling()
	Player.HandleIdle()
	HandleAnimations()

func HandleAnimations():
	Player.Animator.speed_scale = 1
	Player.Animator.play("Running")
	Player.HandleFlipH()
