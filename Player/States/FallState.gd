extends PlayerState

func EnterState():
	stateName = "Fall"

func ExitState():
	if Player.is_on_floor():
		Player.landingSFX.playing = true

func Draw():
	pass

func Update(_delta):
	Player.HandleGravity(_delta, Player.gravityFall)
	Player.HorizontalMov(Player.airAccel, Player.airDecel)
	Player.HandleLanding()
	Player.HandleJumps()
	Player.HandleJumpBuffer()
	HandleAnimations()

func HandleAnimations():
	Player.Animator.play("Falling")
	Player.HandleFlipH()
