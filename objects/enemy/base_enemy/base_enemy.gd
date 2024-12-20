extends Base_enemy

var damage = 1
@export var maxHealth = 1
@onready var currentHealth: int = maxHealth

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
