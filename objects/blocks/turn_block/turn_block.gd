
extends HittableBlock


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounce_timer = $BounceTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bounce_timer.is_stopped():
		position.y += y_speed * delta
		
		if touch: 
			queue_free()
	else:
		$CollisionShape2D.disabled = true
		y_speed += gravity * delta
		position.y += y_speed * delta
		
	

func _bounce() -> void:
	y_speed = initial_bounce_y_speed
	bounce_timer.start()
	touch = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not touch:
		if area.name == "charater":
			_bounce()
	
