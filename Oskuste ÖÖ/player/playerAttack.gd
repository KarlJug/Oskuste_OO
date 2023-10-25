extends Area2D

@onready var area1 = self
var enemy_scene = preload("res://enemy/enemy.tscn")
@onready var enemy = enemy_scene.instantiate()
@onready var animated_sprite_2d = $"../AnimatedSprite2D"
var damage = 50
var attacking = false

func check_for_hits():
	for area in area1.get_overlapping_areas():
		if area.is_in_group("enemies"):
			area.get_parent().get_hit(damage)


func attack():
	# animation
		attacking = true
		animated_sprite_2d.play("attack")
		
		# check if attack connects
		check_for_hits()
		await get_tree().create_timer(0.5).timeout
		attacking = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# attack
	if Input.is_action_just_pressed("ui_mouse_attack") and not attacking:
		attack()


func _on_animated_sprite_2d_animation_finished():
	animated_sprite_2d.play("idle")
