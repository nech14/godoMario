extends HittableBlock


@export var spawner_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self._hittable_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _bounce() -> void:
	var item = spawner_scene.instantiate()
	item.position = Vector2(self.position.x, self.position.y-$ColorRect.size.y)
	get_tree().get_current_scene().add_child(item)


@warning_ignore("unused_parameter")
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "charater":
		_bounce()
	
	
	
