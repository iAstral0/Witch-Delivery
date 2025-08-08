extends PlayerState

func EnterState():
	stateName = "Idle"

func ExitState():
	pass

func Draw():
	pass

func Update(_delta):
	Player.HandleFalling()
	Player.HorizontalMov()
	Player.HandleJumps()
	if (Player.moveDirX != 0):
		Player.ChangeState(states.Run)
	HandleAnimations()

func HandleAnimations():
	Player.Animator.play("Idle")
	Player.HandleFlipH()
