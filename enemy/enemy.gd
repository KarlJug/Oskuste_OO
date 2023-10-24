extends CharacterBody2D

var elud = 100
var facing = true
var turn = false

func die():
	queue_free()

	
	

func get_hit(damage):
	elud -= damage
	print(elud)
	if elud <= 0:
		print("hey")
		$AnimatedSprite2D.play("die")
		await get_tree().create_timer(2).timeout
		die()
func idle():
	turn = true
	match facing:
		true:
			$AnimatedSprite2D.flip_h = true
			facing = false
		false:
			$AnimatedSprite2D.flip_h = false
			facing = true
	await get_tree().create_timer(3).timeout
	turn = false
	
		
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not turn and elud == 100:
		idle()
