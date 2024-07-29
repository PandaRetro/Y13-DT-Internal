extends Node3D


const BONE_LEN = 14.0

@onready var skel = $Armature/Skeleton3D
var angle
var dist = 42.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var list = $Armature/Skeleton3D.find_bone("Bone.003")
	print(list)
	print($Armature/Skeleton3D.get_bone_pose_rotation(list))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dist < 42 and dist > 0:
		angle = 2 * acos(BONE_LEN/dist)
	else:
		angle = 0


	skel.set_bone_pose_rotation(2, Quaternion(angle/2, 0, 0, 1))
	skel.set_bone_pose_rotation(3, Quaternion(-angle/2, 0, 0, 1))
	skel.set_bone_pose_rotation(4, Quaternion(-angle/2, 0, 0, 1))

	if Input.is_action_just_pressed("ui_up"):
		dist += 1
		print(dist)

	if Input.is_action_just_pressed("ui_down"):
		dist -= 1
		print(dist)

	if Input.is_action_just_pressed("ui_left"):
		print(BONE_LEN)
		print(dist)
		print(BONE_LEN/dist)
		print(acos(BONE_LEN/dist))
		print(angle)
