extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group('player'):
		print('open')
		$AnimatedSprite2D.play("open")


func _on_body_exited(body):
	if body.is_in_group('player'):
		print('close')
		$AnimatedSprite2D.play_backwards('open')


func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		get_tree().quit()
