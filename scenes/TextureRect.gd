extends CanvasItem

@export var viewport_path:NodePath

@export var fade_time:float = 0.25
var current_fade_time:float = 0.0
var clear_frame:bool = false

func _process(delta):
	current_fade_time += delta
	if (current_fade_time > fade_time):
		clear_frame = true
		current_fade_time -= fade_time
	queue_redraw()

func _draw():
	if (clear_frame):
		draw_rect(Rect2(0, 0, 512, 512), Color(0.0, 0.0, 0.0, 2.0 / 255.0))
		clear_frame = false
	draw_texture(get_node(viewport_path).get_texture(), Vector2())
