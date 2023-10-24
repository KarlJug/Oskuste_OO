extends Area2D

@onready var area1 = self
var enemy_scene = preload("res://enemy/enemy.tscn")
@onready var enemy = enemy_scene.instantiate()
var damage = 50

func check_for_hits():
	for area in area1.get_overlapping_areas():
		if area.is_in_group("enemies"):
			print("yes sir")
			enemy.get_hit(damage)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# attack
	if Input.is_action_just_pressed("ui_mouse_attack"):
		# aniumation
		
		# check if attack connects
		check_for_hits()
