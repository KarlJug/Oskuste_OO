extends CharacterBody2D

@onready var dash_raycast = $RayCast2D

var area1 : Area2D
var original_pos : Vector2
var dash_raycast_pos : Vector2

const SPEED = 400.0
const JUMP_VELOCITY = -1300.0
var is_dashing = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func player_dash():
	if is_dashing:
		return
	
	is_dashing = true
	
	# Calculate the dash direction based on the mouse cursor position
	var dash_vector = get_global_mouse_position() - global_position
	dash_vector  = dash_vector.normalized()
	
	var vec_x = 1
	if dash_vector.x < 0:
		vec_x = -1
		
	else:
		vec_x = 1
	
	# ray cast flip
	dash_raycast.position.x = vec_x * dash_raycast_pos.x

	if dash_raycast.rotation == 0 and vec_x == -1:
		dash_raycast.rotation = 3
	elif dash_raycast.rotation == 3 and vec_x == 1:
		dash_raycast.rotation = 0
	
	var step = 0
	var distance = 10
	while 20 > step:
		if is_on_wall() or dash_raycast.is_colliding():
			break
		
		self.position.x += vec_x * distance

		
		await get_tree().create_timer(0.00000000000000000000000001).timeout  # smoothness
		step += 1
	
	is_dashing = false


func _on_dash_completed():
	is_dashing = false


func _ready():
	dash_raycast_pos = dash_raycast.position
	area1 = $area1
	if area1:
		original_pos = area1.position
		
	else:
		print("area not found")
		return 1


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_mouse_dash"):
		player_dash()
		
	# Handle Jump.
	elif Input.is_action_just_pressed("ui_up") and is_on_floor() and not $area1.attacking:
		velocity.y = JUMP_VELOCITY

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += (gravity + 4000) * delta
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		if velocity.y > 0:
			$AnimatedSprite2D.play("falling")


	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and not $area1.attacking:
		if Input.is_action_just_pressed("ui_mouse_dash") and not is_dashing:
			player_dash()
			
		elif not is_dashing:
			velocity.x = direction * SPEED
			
			# running animation flip logic and play
			if direction < 0:
				$AnimatedSprite2D.flip_h = true
				if is_on_floor():
					$AnimatedSprite2D.play("running")
			elif direction > 0:
				$AnimatedSprite2D.flip_h = false
				if is_on_floor():
					$AnimatedSprite2D.play("running")
				
			# attack hitbox flip
			area1.position.x = direction * original_pos.x
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# idle animation
		if not $area1.attacking and is_on_floor():
			$AnimatedSprite2D.play("idle")

	move_and_slide()
