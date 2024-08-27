extends Node3D

@onready var skel = $Armature/Skeleton3D
@onready var target = get_node("/root/Main/Entities/CharacterBody3D/Head")
#@onready var mesh_ar = ArrayMesh.new()
#@onready var mesh = MeshInstance3D.new()

var target_pos
var iterations = 10
var limbs = 10
var limb_len = 2

var weights = [0.1,0.2,0.3,0.4,0.7,1,1,1,1,1,1,1]

func _ready():
	pass


func _process(delta):
	if true:
		#var rott = Quaternion(Vector3(1,0,0),Vector3(0,1,0))
		#print(skel.get_bone_global_pose(1)) # basis shows the changed rotation, just get basis.y adn target vec
		#var rot_2 = Quaternion(skel.get_bone_global_pose(1).basis.y, Vector3(0,1,0)) # go from pervious basis.y to new vector
		target_pos = target.global_transform.origin
		if target_pos.length() > (limb_len *limbs):
			target_pos = target_pos.normalized() * (limb_len * limbs)

		var cur_pos = []
		var index
		for i in range(skel.get_bone_count()):
			if i > 0:
				index = skel.get_bone_children(index)[0]
			else:
				index = 0
			cur_pos.append(to_global(skel.get_bone_global_pose(index).origin))


		cur_pos.append(target_pos)
		for iteration in iterations:
			for i in range(skel.get_bone_count()):
				var j = len(cur_pos) - (i + 1)
				var diff_in_points_backward
				diff_in_points_backward = cur_pos[j - 1] - cur_pos[j]
				if diff_in_points_backward.length() != limb_len:
					cur_pos[j - 1] = cur_pos[j] + (diff_in_points_backward.normalized() * limb_len)


			if cur_pos[0].length() != 0:
				cur_pos[0] = Vector3(0, 0, 0)
			for i in range((skel.get_bone_count() - 1)):
				var diff_in_points_forward
				diff_in_points_forward = cur_pos[i + 1] - cur_pos[i]
				if diff_in_points_forward.length() != limb_len:
					cur_pos[i + 1] = cur_pos[i] + (diff_in_points_forward.normalized() * limb_len)


		#cur_pos = [Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(1, 0, 0),]
		for i in range(skel.get_bone_count()):
			var new_dir = (cur_pos[i+1] - cur_pos[i]).normalized()
			var rot
			var x_dir
			var y_dir
			var z_dir
			var trans
			if i != 0:
				rot = Quaternion(skel.get_bone_global_pose(i-1).basis.y, new_dir).normalized()  #skel.get_bone_global_pose(i).basis.y
			else:
				rot = Quaternion(Vector3(0, 1, 0), new_dir).normalized()

			if rot != Quaternion(0, 0, 0, 1):
				y_dir = Basis(rot).y
				x_dir = Basis(rot.get_axis(), PI/2).y #Basis(Quaternion(rot.x, rot.y, rot.z, cos((rot.get_angle() - PI/2) / 2))).y
				z_dir = rot.get_axis()
				trans = Transform3D(Basis(x_dir, y_dir, x_dir), cur_pos[i])
				print(x_dir)
				print(y_dir)
				print(z_dir)
				print("hi")
			else:
				trans = Transform3D(rot, cur_pos[i])

			skel.set_bone_global_pose_override(i, trans, 0.5, true)
			
#Quaternion(Vector3(0, 1, 0), new_dir)

























