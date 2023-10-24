extends CharacterBody2D

var elud = 100

func die():
	# animation
	
	queue_free()

func get_hit(damage):
	elud -= damage
	print(elud)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if elud <= 0:
		print("hey")
		die()
