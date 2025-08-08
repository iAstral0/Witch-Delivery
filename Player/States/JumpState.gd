extends PlayerState

func EnterState():
	stateName = "Jump"
	Player.velocity.y = Player.jumpSpeed
	Player.jumpSFX.playing = true

func ExitState():
	pass

func Draw():
	pass

func Update(_delta):
	Player.HandleGravity(_delta)
	Player.HorizontalMov()
	HandleJumpToFall()
	HandleAnimations()

func HandleJumpToFall():
	if (Player.velocity.y >= 0):
		Player.ChangeState(states.Fall)
	if (!Player.movJump):
		Player.velocity.y *= Player.varJumpMult
		Player.ChangeState(states.Fall)

func HandleAnimations():
	Player.Animator.play("Jumping")
	Player.HandleFlipH()
