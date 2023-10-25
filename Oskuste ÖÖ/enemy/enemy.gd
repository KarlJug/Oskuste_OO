extends CharacterBody2D

@onready var ray_cast_2d = $RayCast2D
@onready var ray_cast_attack = $RayCastAttack

var ray_cast_pos : Vector2
var ray_cast_attack_pos : Vector2

var elud = 100
var facing = true
var turn = false
var moving_right = true
var direction_x = 1
var SPEED = 70


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func die():
	# animation
	$AnimatedSprite2D.play("die")
	await get_tree().create_timer(2).timeout
	queue_free()


func get_hit(damage):
	elud -= damage
	if elud <= 0:
		die()


func idle():
	turn = true
	var turns = 0
	
	while 2 >= turns:
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
	
	$AnimatedSprite2D.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_on_floor():
		velocity.y += (gravity + 4000) * delta
	
	# movment and turn logic
	if not ray_cast_2d.is_colliding() or is_on_wall():
		if direction_x < 0:
			direction_x = 1
		else:
			direction_x = -1
		
		ray_cast_2d.position.x *= -1  # if not work use: direction_x * ray_cast_pos.x
		ray_cast_attack.position.x *= -1  # direction_x * ray_cast_attack_pos.x
		ray_cast_attack.scale.x *= -1
		idle()
	
	if not turn:
		velocity.x = direction_x * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
