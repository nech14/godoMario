extends Node2D

var roch = false
@export var spawner_scene: PackedScene
var item
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	item = spawner_scene.instantiate()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_script_area_exited(area: Area2D) -> void:
	if !roch and area.name == "hitBox" and area.get_parent().name == "Player":
		roch = true
		item.position = Vector2(1050, 150)
		add_child(item)
		
