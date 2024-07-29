extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var list = $Armature/Skeleton3D.get_bone_children(1)
	print(list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
