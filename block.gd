extends StaticBody2D

@export var gravity: float = 3600.0
@export var initial_bounce_y_speed: float = -500



var y_speed: float = 0.0
var bounce_timer: Timer
var destroy = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bounce_timer = $BounceTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bounce_timer.is_stopped():
		position.y += y_speed * delta
		y_speed = 0
		
		if destroy: 
			queue_free()
	else:
		$CollisionShape2D.disabled = true
		y_speed += gravity * delta
		position.y += y_speed * delta
		
	

func _bounce() -> void:
	y_speed = initial_bounce_y_speed
	bounce_timer.start()
	destroy = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not destroy:
		if area.name == "charater":
			_bounce()
	
