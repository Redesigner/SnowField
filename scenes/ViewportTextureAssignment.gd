extends CanvasItem

@export var viewport_path:NodePath
@export var texture_name:String

func _ready():
	material.set_shader_parameter(texture_name, get_node(viewport_path).get_texture())
