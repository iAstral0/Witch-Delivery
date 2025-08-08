extends Node

@onready var interactTexture = $"../UI/TextureRect"
var hasPackage = false
var packageType = null

# Area Entered
var enteredPackageArea = false
var enteredWitchArea = false
var witchRangeType  = null
signal PackageDelivered
signal PackagePickedUp

func SetInteract():
	interactTexture.visible = (enteredPackageArea and !hasPackage) or (enteredWitchArea and hasPackage and witchRangeType == packageType)

func SetPackageArea(state: bool):
	enteredPackageArea = state
	SetInteract()

func SetWitchArea(state: bool, witchType: String):
	enteredWitchArea = state
	if (state == true):
		witchRangeType = witchType
	else:
		witchRangeType = null
	SetInteract()

func playerInteract():
	if enteredPackageArea and !hasPackage:
		var packageTypes = ["blue", "green", "yellow", "orange"]
		packageType = packageTypes[randi() % packageTypes.size()]
		hasPackage = true
		print("Picked up package: " + packageType)
		emit_signal("PackagePickedUp")
		SetInteract()
		
	elif enteredWitchArea and hasPackage and witchRangeType == packageType:
		hasPackage = false
		print("Package has been delivered")
		packageType = null
		emit_signal("PackageDelivered")
		SetInteract()

