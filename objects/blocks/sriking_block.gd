
extends HittableBlock

var last_position: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounce_timer = $BounceTimer
	bounce_timer.wait_time = wait_time
	last_position = position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not touch and bounce_timer.is_stopped():	
		pass
	elif position.y > last_position:
		touch = false
		y_speed = 0
		bounce_timer.stop()
		position.y = last_position
	elif touch:
		y_speed += (gravity)/2 * delta		
	else:
		y_speed = 0
		bounce_timer.stop()
		
	if touch:	
		position.y += y_speed * delta
		
	

func _bounce() -> void:
	y_speed = initial_bounce_y_speed
	bounce_timer.start()
	touch = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not touch:
		if area.name == "charater":
			_bounce()
