
extends StaticBody2D

class_name Item


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _below(character=null):
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "hitBox":
		_below()
