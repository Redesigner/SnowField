extends CharacterBody3D

@onready var sprite:AnimatedSprite3D = get_node("CollisionShape3D/AnimatedSprite3D")
@onready var audio_stream_player:AudioStreamPlayer3D = get_node("AudioStreamPlayer3D")
@onready var snowball_mesh:MeshInstance3D = get_node("ShowballCollisionShape/SnowballMesh")
@onready var snowball_collision:CollisionShape3D = get_node("ShowballCollisionShape")

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var is_walking:bool = false
@export var footstep_next_time:float = 0.35
var footstep_current_time:float = 0.0

@export var volume_min:float = -15.0
@export var volume_max:float = -10.0

var snowball_radius:float = 0.1
@export var snowball_growth_rate:float = 1.0

var current_direction_angle:float = 0.0

var pushing_snowball:bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	if (is_walking):
		sprite.play("walk")
		footstep_current_time += delta
		if (footstep_current_time >= footstep_next_time):
			footstep_current_time -= footstep_next_time
			audio_stream_player.volume_db = randf_range(volume_min, volume_max)
			audio_stream_player.play()
	else:
		sprite.pause()

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir_normalized = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var speed:float = SPEED * clamp(0.5 / snowball_radius, 0.0, 1.0)
	
	is_walking = !input_dir_normalized.is_zero_approx()
	
	if (!is_on_floor()):
		velocity.y -= gravity * delta
		#print("%f %f" % [position.y, velocity.y])
	else:
		velocity.y = max(velocity.y, 0.0)
		
	if input_dir_normalized:
		var desired_direction_angle:float = rad_to_deg(atan2(input_dir_normalized.z, input_dir_normalized.x))
		var rotation_speed:float = clampf(1.0 / snowball_radius, 1.0, 10.0) if pushing_snowball else 180.0
		current_direction_angle = Math.angle_interp_to_constant(current_direction_angle, desired_direction_angle, rotation_speed)
		var current_direction_angle_rad:float = deg_to_rad(current_direction_angle)
		var direction:Vector2 = Vector2(cos(current_direction_angle_rad), sin(current_direction_angle_rad))
	
		velocity.x = direction.x * speed
		velocity.z = direction.y * speed
		
		snowball_collision.position.x = (0.4 + snowball_radius) * direction.x
		snowball_collision.position.z = (0.4 + snowball_radius) * direction.y
		sprite.flip_h = (direction.x < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.y, 0, speed)

	var old_position:Vector3 = position

	move_and_slide()
	
	if (pushing_snowball):
		var distance_moved = (position - old_position).length()
		snowball_radius += distance_moved * snowball_growth_rate / 100
		snowball_radius = clamp(snowball_radius, 0, 1)
		snowball_collision.position.y = snowball_radius - 0.1
				
		snowball_mesh.scale = Vector3(snowball_radius, snowball_radius, snowball_radius)
		snowball_collision.shape.radius = max(snowball_radius - 0.2, 0.0)

func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		get_tree().quit()
		
	if (event.is_action_pressed("interact")):
		if (pushing_snowball):
			spawn_snowball()
			pushing_snowball = false
			snowball_collision.disabled = true
			snowball_mesh.visible = false
		else:
			pushing_snowball = true
			snowball_collision.disabled = false
			snowball_mesh.visible = true

func spawn_snowball():
	var snowball_position:Vector3 = snowball_collision.global_position
	var new_snowball:CollisionShape3D = snowball_collision.duplicate()
	var snowball_parent:StaticBody3D = StaticBody3D.new()
	snowball_parent.add_child(new_snowball)
	get_tree().root.add_child(snowball_parent)
	snowball_parent.global_position = snowball_position
	new_snowball.position = Vector3(0.0, 0.0, 0.0)
	new_snowball.shape = SphereShape3D.new()
	new_snowball.shape.radius = snowball_collision.shape.radius
	snowball_radius = 0.1
