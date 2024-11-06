extends Item

@export
var count_coins = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _below() -> void:
	queue_free()
	GameState.give_coins(count_coins)
	
func _above() -> void:
	queue_free()
	
