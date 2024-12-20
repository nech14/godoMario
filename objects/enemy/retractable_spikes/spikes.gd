extends Base_enemy

@onready var open_timer: Timer = $OpenTimer
@onready var close_timer: Timer = $CloseTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var opened = false
var character_inside = false
var character_body = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _cause_damage(character=null):
	if !opened and open_timer.is_stopped():
		open_timer.start()
		animated_sprite_2d.play("default")
	else:
		character._take_damage()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "hitBox" and area.get_parent().name == "Player":
		character_body = area.get_parent()
		_cause_damage(character_body)
		character_inside = true


func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.name == "hitBox" and area.get_parent().name == "Player":
		character_inside = false
		character_body = null


func _on_open_timer_timeout() -> void:
	opened = true
	close_timer.start()
	if character_inside:
		_cause_damage(character_body)


func _on_close_timer_timeout() -> void:
	opened = false
