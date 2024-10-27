extends Node3D

@onready var skel = $Armature/Skeleton3D
@onready var target = get_node("/root/Main/Entities/CharacterBody3D")

var iterations = 1
var limb_len = 2 * 0.3


func _ready():
	pass


func _process(delta):
	var target_pos = target.position
	#print(target_pos)
	#var cur_pos = []
	#var index
	#for i in range(skel.get_bone_count()):
		#if i > 0:
			#index = skel.get_bone_children(index)[0]
		#else:
			#index = 0
		#cur_pos.append(to_global(skel.get_bone_global_pose(index).origin))
#
#
	#cur_pos[len(cur_pos) - 1] = target_pos
	#for iteration in iterations:
		#for i in range(len(cur_pos)):
			#var j = len(cur_pos) - (i + 1)
			#var diff_in_points_backward
			#if j == 0:
				#diff_in_points_backward = - cur_pos[j]
			#else:
				#diff_in_points_backward = cur_pos[j - 1] - cur_pos[j]
#
			#if diff_in_points_backward.length() != limb_len:
				#cur_pos[j - 1] = cur_pos[j] + (diff_in_points_backward.normalized() * limb_len)
#
#
		#for i in range(len(cur_pos)):
			#var diff_in_points_forward
			#if i == (len(cur_pos) - 1):
				#diff_in_points_forward = target_pos - cur_pos[i]
				#if diff_in_points_forward.length() != 0:
					#cur_pos[i] = cur_pos[i] + diff_in_points_forward
			#else:
				#diff_in_points_forward = cur_pos[i + 1] - cur_pos[i]
				#if diff_in_points_forward.length() != limb_len:
					#cur_pos[i + 1] = cur_pos[i] + (diff_in_points_forward.normalized() * limb_len)
#
#
	#for i in range(len(cur_pos)):
		#if i == (len(cur_pos) -1):
			#pass
		#elif (cur_pos[i + 1] - cur_pos[i]).normalized() != Vector3(0, 1, 0):
			#print("----------------")
			#print((cur_pos[i + 1] - cur_pos[i]).normalized())
			#var rot = Basis.IDENTITY.looking_at((cur_pos[i + 1] - cur_pos[i]).normalized(), Vector3(0, 1, 0))
			#print(rot)
			#var pos = cur_pos[i]
			#var trans = Transform3D(rot, pos)
			#skel.set_bone_global_pose_override(i, trans, 1, false)
			#skel.set_bone_pose_rotation()
	#
 #
#
#
#
#
#
#
#
#
#
#
#
