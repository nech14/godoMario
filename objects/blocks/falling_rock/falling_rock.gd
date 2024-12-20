extends StaticBody2D

@onready var destruction_timer: Timer = $DestructionTimer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var shake_intensity = 1.0  # Сила тряски
var original_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !destruction_timer.is_stopped():
		position = original_position + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		position = original_position  # Возвращаем блок в исходное положение
		

func start_shake(intensity: float) -> void:
	shake_intensity = intensity
	original_position = position  # Сохраняем начальную позицию


func _on_area_2d_area_entered(area: Area2D) -> void:
	if destruction_timer.is_stopped() and area.name == "hitBox" and area.get_parent().name == "Player":
		destruction_timer.start()
		animated_sprite_2d.play("default")


func _on_destruction_timer_timeout() -> void:
	collision_shape_2d.disabled = true



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
