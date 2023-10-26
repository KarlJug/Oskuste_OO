extends CharacterBody2D
@onready var player_scene = $"../player"
@onready var ray_cast_2d = $RayCast2D
@onready var ray_cast_attack = $RayCastAttack
@onready var area_2 = $area2
@onready var damage_area = $damageArea

var ray_cast_pos : Vector2
var ray_cast_attack_pos : Vector2


var elud = 100
var facing = true
var turn = false
var moving_right = true
var direction_x = 1
var SPEED = 70
var is_dead = false
var is_attacking = false
var is_dashing = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func dash_attack():
	if is_dashing:
		return
	
	is_dashing = true
	
	var step = 0
	var distance = 10
	while 20 > step:
		if not ray_cast_2d.is_colliding() or is_on_wall() or is_dead or not is_attacking:
			break
		
		self.position.x += direction_x * distance
		
		await get_tree().create_timer(0.04).timeout  # smoothness
		step += 1
	
	is_dashing = false


func die():
	# layers
	# Remove the specific mask you want to stop checking (e.g., mask 4)
	var new_collision_mask = 1 << 2  # For mask 2
	
	# Assign the updated collision mask back to the node
	self.collision_mask &= ~new_collision_mask
	area_2.collision_mask &= ~new_collision_mask
	damage_area.collision_mask &= ~new_collision_mask
	# animation
	$AnimatedSprite2D.play("die")
	await get_tree().create_timer(2).timeout
	queue_free()


func get_hit(damage):
	elud -= damage
	if elud <= 0:
		
		is_dead = true
		$AnimatedSprite2D.stop()
		die()


func idle():
	turn = true
	var turns = 0
	
	while 2 >= turns and not is_dead and not is_attacking:
		$AnimatedSprite2D.play("idle")
		match facing:
			true:
				$AnimatedSprite2D.flip_h = true
				facing = false
			
			false:
				$AnimatedSprite2D.flip_h = false
				facing = true
			
		await get_tree().create_timer(1).timeout
		turns += 1
		
	turn = false


# Called when the node enters the scene tree for the first time.
func _ready():
	ray_cast_pos = ray_cast_2d.position
	ray_cast_attack_pos = ray_cast_attack.position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_wall():
		pass
	
	if ray_cast_attack.is_colliding():
		if ray_cast_attack.get_collider().get_name() == "player" and not is_dead:
			is_attacking = true
			await get_tree().create_timer(1.7).timeout
			dash_attack()
		
	else:
		is_attacking = false
	
	if not is_on_floor():
		velocity.y += (gravity + 4000) * delta
	
	# movment and turn logic
	if not is_dead and not is_attacking and not ray_cast_2d.is_colliding() or is_on_wall():
		if direction_x < 0:
			direction_x = 1
		else:
			direction_x = -1
		
		ray_cast_2d.position.x *= -1  # if not work use: direction_x * ray_cast_pos.x
		ray_cast_attack.position.x *= -1  # direction_x * ray_cast_attack_pos.x
		ray_cast_attack.scale.x *= -1
		idle()
		await get_tree().create_timer(1.7).timeout
	
	if not turn and not is_attacking and not is_dead:
		velocity.x = direction_x * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func _on_damage_area_body_entered(body):
	print(global_position)
	if body.get_name() == "player" and not is_dead:
			print("hit")
			var direction = (global_position - body.global_position).normalized()
			var explosionForce = direction * body.explosionForce
			body.elud -= 10
			print(body.elud)
			
			var step = 0  # dont change
			var max_steps = 4
			explosionForce /= max_steps
			while max_steps > step:
				if body.is_on_wall() or body.is_on_ceiling():
					break
				
				body.position -= explosionForce
				
				await get_tree().create_timer(0.007).timeout  # smoothness
				step += 1
