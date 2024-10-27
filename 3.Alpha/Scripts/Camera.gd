extends Camera3D

var char
var lerp_weight = 0.05

func _ready():
	char = get_node("/root/Main/Character")


func _process(delta):
	# Follow player and rotate to keep in frame
	self.position.x = lerp(self.position.x, char.position.x, lerp_weight)
	var z = self.position.z - char.position.z
	var y = self.position.y - char.position.y
	var angle = atan(z/y)
	self.rotation.x = lerp(self.rotation.x, -((PI/2) - angle), lerp_weight)
