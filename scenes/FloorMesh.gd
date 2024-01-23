extends MeshInstance3D

func _ready():
	mesh.material.set_shader_parameter("displacement_texture", get_node("../../GaussianBlur").get_texture())
