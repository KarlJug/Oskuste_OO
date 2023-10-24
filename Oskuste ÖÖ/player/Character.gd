extends CharacterBody2D


var area1 : Area2D
var original_pos : Vector2

const SPEED = 400.0
const JUMP_VELOCITY = -1300.0
var is_dashing = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func player_dash(dash_direction):
	if is_dashing:
		return
	
	const x_speed = 3600
	const y_speed = 1500  # 1200
	
	velocity.x = dash_direction.x * x_speed
	velocity.y = dash_direction.y * y_speed
	is_dashing = true
	await get_tree().create_timer(0.13).timeout
	is_dashing = false


func _ready():
	area1 = $area1
	if area1:
		original_pos = area1.position
		
	else:
		print("area not found")


func _physics_process(delta):
	
	#print(is_dashing)
	# mouse pos for dash
	var mouse_pos = get_global_mouse_position()
	var dash_direction = (mouse_pos - global_position).normalized()
	
	#print(dash_direction)
	
	if is_on_floor():
		is_dashing = false
	
	if Input.is_action_just_pressed("ui_mouse_dash"):
		player_dash(dash_direction)
		
	# Handle Jump.
	elif Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	# Add the gravity.
	if not is_on_floor() and not is_dashing:
		velocity.y += (gravity + 4000) * delta


	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not is_dashing or is_on_floor():
		if Input.is_action_just_pressed("ui_mouse_dash"):
			player_dash(dash_direction)
			
		elif not is_dashing:
			velocity.x = direction * SPEED
		
			# attack hitbox flip
			area1.position.x = direction * (original_pos.x * 5)
			#print(original_pos)
		
		
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
