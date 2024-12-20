extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _bounce():
	animated_sprite_2d.play("default")
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "charater":
		_bounce()
	


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
