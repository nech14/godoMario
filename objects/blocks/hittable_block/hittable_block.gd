extends StaticBody2D

class_name HittableBlock

@export var gravity: float = 3600.0
@export var initial_bounce_y_speed: float = -500.0

var y_speed: float = 0.0

var bounce_timer: Timer
@export
var wait_time = 0.2
var touch = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_hittable_ready()



# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
		
	

func _bounce() -> void:
	pass


@warning_ignore("unused_parameter")
func _on_area_2d_area_entered(area: Area2D) -> void:
	pass
	

func _hittable_ready() -> void:
	bounce_timer = $BounceTimer
	bounce_timer.wait_time = wait_time
