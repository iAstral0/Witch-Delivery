class_name PlayerContoller extends CharacterBody2D

#Player Variable
# Nodes
@onready var Sprite = $Sprite2D
@onready var Collider = $CollisionShape2D
@onready var Animator = $AnimationPlayer
@onready var States = $StateMachine
@onready var InteractManager = $InteractionManager
@onready var Package = $Packages
@onready var PackageSprite = $Packages/Sprite2D

# Effects
@onready var PackageParticles = $Effects/PackageParticle
@onready var DeliveredParticles = $Effects/DeliveredParticle

# Sounds
@onready var pickedUpSFX = $Sound/Picked
@onready var deliveredSFX = $Sound/Delivered
@onready var musicBG = $Sound/Music
@onready var jumpSFX = $Sound/Jump
@onready var landingSFX = $Sound/Landing

# Timers
@onready var jumpBuffer_Timer = $Timers/JumpBuffer
@onready var coyote_Timer = $Timers/CoyoteTimer

# Physics Variables
const runSpeed = 140
const groundAccel = 40
const groundDecel = 50
const airAccel = 15
const airDecel = 20
const jumpGrav = -175
const gravityJump = 600
const gravityFall = 700
const maxFallVelocity = 700
const varJumpMult = 1
const maxJumps = 1
const jumpBufferTime = 0.3
const coyoteTime = 0.3

var accel = groundAccel
var decel = groundDecel
var movSpeed = runSpeed
var jumpSpeed = jumpGrav
var moveDirX = 0
var jumps = 0
var facing = 1

# Objects
const floatAmp = 5
const floatSpeed = 5
var floatTimer = 0
var basePackagePos = Vector2.ZERO
var targetPackagePos = Vector2.ZERO
var sizeVar = 0
var lastPackageType = null

# Input Variables
var movUp = false
var movDown = false
var movLeft = false
var movRight = false
var movJump = false
var movJumpPressed = false
var buttonInteract = false

# State Machine
var currState = null
var prevState = null
var nextState = null

func _ready():
	for state in States.get_children():
		state.states = States
		state.Player = self
	prevState = States.Fall
	currState = States.Fall
	musicBG.playing = true

func _draw():
	currState.Draw()

func _physics_process(delta):
	# Input State
	GetInputStates()
	
	# Update Current State
	currState.Update(delta)
	
	# Handle State Change
	HandleStateChange()
	
	# Handle Interact
	HandleInteract()
	
	# Handle Movement
	HandleMaxVelocity()
	
	# Movement
	HorizontalMov()
	move_and_slide()
	
	# Package
	PackageFollow()

func GetInputStates():
	movUp = Input.is_action_pressed("Up")
	movDown = Input.is_action_pressed("Down")
	movLeft = Input.is_action_pressed("Left")
	movRight = Input.is_action_pressed("Right")
	movJump = Input.is_action_pressed("Jump")
	movJumpPressed = Input.is_action_just_pressed("Jump")
	buttonInteract = Input.is_action_pressed("Interact")
	
	if movRight: facing = 1
	if movLeft: facing = -1

func HorizontalMov(Accel: float = accel, Decel: float = decel):
	moveDirX = Input.get_axis("Left", "Right")
	var _targetspeed = (moveDirX * movSpeed)
	if (moveDirX != 0):
		velocity.x = move_toward(velocity.x, _targetspeed, Accel)
	else:
		velocity.x = move_toward(velocity.x, _targetspeed, Decel)

func ChangeState(targetState):
	if (targetState):
		nextState = targetState

func HandleStateChange():
	if (nextState != null):
		if (currState != nextState):
			prevState = currState
			currState.ExitState()
			currState = null
			currState = nextState
			currState.EnterState()
			#print("State From : " + prevState.stateName + " To : " + currState.stateName)
		nextState = null

func HandleInteract():
	if buttonInteract:
		InteractManager.playerInteract()


func HandleFlipH():
	Sprite.flip_h = (facing < 1)

func HandleMaxVelocity():
	if (velocity.y > maxFallVelocity):
		velocity.y = maxFallVelocity

func HandleGravity(delta, Gravity : float = gravityJump):
	if (!is_on_floor()):
		velocity.y += Gravity * delta

func HandleIdle():
	if (moveDirX == 0):
		ChangeState(States.Idle)
	elif(is_on_floor()):
		jumps = 0

func HandleFalling():
	if (!is_on_floor()):
		coyote_Timer.start(coyoteTime)
		ChangeState(States.Fall)

func HandleJumps():
	if (is_on_floor()):
		if (jumps < maxJumps):
			if (movJumpPressed or jumpBuffer_Timer.time_left > 0):
				jumpBuffer_Timer.stop()
				jumps += 1
				ChangeState(States.Jump)
	else:
		if ((jumps < maxJumps) and (jumps > 0) and movJumpPressed):
			jumps += 1
			ChangeState(States.Jump)
		
		if (coyote_Timer.time_left > 0):
			if ((movJumpPressed) and (jumps < maxJumps)):
				jumps += 1
				coyote_Timer.stop()
				ChangeState(States.Jump)

func HandleJumpBuffer():
	if (movJumpPressed):
		jumpBuffer_Timer.start(jumpBufferTime)

func HandleLanding():
	if (is_on_floor()):
		jumps = 0
		ChangeState(States.Idle)

func PackageFollow():
	var followOffsetX = 10
	var followOffsetY = -10
	
	if InteractManager.hasPackage:
		if facing > 0:
			followOffsetX *= -1
		elif facing < 0:
			followOffsetX *= 1
		
		targetPackagePos = global_position + Vector2(followOffsetX, followOffsetY)
		if !Package.visible:
			basePackagePos = position
		
		UpdatePackageColor()
		PackageMoves()
		PackageParticles.global_position = Package.global_position
		Package.visible = true
		PackageParticles.emitting = true
		PackageFloating()
	elif !InteractManager.hasPackage:
		Package.visible = false
		floatTimer = 0

func PackageMoves():
	floatTimer += floatSpeed * get_process_delta_time()
	Package.global_position = basePackagePos + Vector2(0, sin(floatTimer) * floatAmp)

func PackageFloating():
	if basePackagePos != targetPackagePos:
		var tween = create_tween()
		tween.tween_property(self, "basePackagePos", targetPackagePos, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func UpdatePackageColor():
	var packageColor = InteractManager.packageType
	
	if lastPackageType != packageColor:
		sizeVar = randi() % 2
		lastPackageType = packageColor
	
	var packageColorIndex = 0
	match packageColor:
		"blue":
			packageColorIndex = 0
		"green":
			packageColorIndex = 1
		"yellow":
			packageColorIndex = 2
		"orange":
			packageColorIndex = 3
	
	var frameIndex = packageColorIndex + sizeVar * 4
	PackageSprite.frame = frameIndex

func _on_interaction_manager_package_delivered():
	deliveredSFX.playing = true
	DeliveredParticles.global_position = Package.global_position
	DeliveredParticles.emitting = true

func _on_interaction_manager_package_picked_up():
	pickedUpSFX.playing = true
