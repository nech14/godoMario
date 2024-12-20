extends HittableBlock


@export var spawner_scene: PackedScene
var used = false
var last_position: float
var item 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._hittable_ready()
	bounce_timer = $BounceTimer
	bounce_timer.wait_time = wait_time
	last_position = position.y
	item = spawner_scene.instantiate()


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
		if is_instance_valid(item):
			item.position.y += y_speed * delta
	

func _bounce() -> void:
	#item.position = Vector2(self.position.x, self.position.y-$ColorRect.size.y)
	item.position = Vector2(self.position.x, self.position.y - item.size)
	get_tree().get_current_scene().add_child(item)
	y_speed = initial_bounce_y_speed
	bounce_timer.start()
	touch = true
	used = true
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D2.visible = true


@warning_ignore("unused_parameter")
func _on_area_2d_area_entered(area: Area2D) -> void:
	if !used and area.name == "charater":
		_bounce()
	
	
	
