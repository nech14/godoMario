
extends Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _below(character=null):	
	queue_free()
	character.powerup_state = character.PowerupState.BIG


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "hitBox":
		var perant = area.get_parent()
		_below(perant)
