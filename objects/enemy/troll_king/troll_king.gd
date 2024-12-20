
extends BaseMoveEnemy

@export var direction = 1 
@onready var anim = $AnimatedSprite2D
@onready var gpu_particles_2d_right: GPUParticles2D = $GPUParticles2DRight
@onready var gpu_particles_2d_left: GPUParticles2D = $GPUParticles2DLeft
@onready var player = null 
@onready var timer: Timer = $Timer
@onready var rest_timer: Timer = $RestTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var animation_queue: Array = []  # Очередь анимаций
var is_playing_queue = false  # Флаг для контроля очереди


var is_chasing = false
var player_in_radius = false
var die = false
@export var hp = 50
var anim_playing = false
var attacking = false
var rest = false

func _ready() -> void:
	anim.play("eatting")

func _physics_process(delta: float) -> void:
	
	if die:
		return
		
	if is_chasing and player and !attacking and !is_playing_queue:
		if rest:
			anim.play("default")
		else:		
			var direction = (player.position - position).normalized()
			velocity = direction * SPEED
		
			#velocity.x = direction * SPEED
			if direction.x < 0:
				anim.flip_h = true
			elif anim.flip_h:
				anim.flip_h = false
			
		
			anim.play("move")
	else:
		velocity.x = 0
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _below(character=null) -> void:
	pass
	
func _die() -> void:
	hp -= 1
	start_blinking()
	if hp < 0:
		die = true
		anim.play("die")
		$CollisionShape2D.disabled = true
		
func start_blinking(duration = 0.3, blink_rate = 0.1):
	var blink_timer = Timer.new()
	blink_timer.wait_time = blink_rate
	blink_timer.autostart = true
	blink_timer.one_shot = false
	blink_timer.connect("timeout", Callable(self, "_on_blink_timer_timeout"))
	add_child(blink_timer)
	
	await get_tree().create_timer(duration).timeout
	blink_timer.queue_free()
	animated_sprite_2d.modulate = Color(1, 1, 1, 1)  # Возвращаем обычный цвет

func _on_blink_timer_timeout():
	animated_sprite_2d.modulate = Color(1, 0, 0, 1) if animated_sprite_2d.modulate == Color(1, 1, 1, 1) else Color(1, 1, 1, 1)
		

func _take_damage(character=null) -> void:
	attacking = true
	play_animation_queue("attack")
	timer.start()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if die:
		return
		
	if area.name == "hitBox" and area.get_parent().name == "PlayerFireball":
		area.get_parent().queue_free()
		_take_damage()
		

	
		


func _on_eyes_body_entered(body: Node2D) -> void:
	if body.is_in_group("block"):
		direction = -direction

func play_animation_queue(animations: String) -> void:
	animation_queue.append(animations)
	is_playing_queue = true
	_play_next_animation()


func _play_next_animation() -> void:
	if animation_queue.size() > 0:
		var next_animation = animation_queue.pop_front()
		anim.play(next_animation)
	else:
		is_playing_queue = false  # Очередь завершена


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_playing_queue:
		_play_next_animation()
	
	if die:
		queue_free()


func _on_eyes_area_entered(area: Area2D) -> void:	
	if !attacking and area.name == "hitBox" and area.get_parent().name == "Player":
		player = area.get_parent()
		is_chasing = true
		play_animation_queue("stay")
		play_animation_queue("finds")


func _on_eyes_area_exited(area: Area2D) -> void:
		
	if area.name == "hitBox" and area.get_parent().name == "Player":
		player = null
		is_chasing = false
		play_animation_queue("eatting")


func _on_damage_box_area_entered(area: Area2D) -> void:
	if area.name == "hitBox" and area.get_parent().name == "Player":
		_take_damage()
		player_in_radius = true


func _on_damage_box_area_exited(area: Area2D) -> void:
	if area.name == "hitBox" and area.get_parent().name == "Player":
		player_in_radius = false


func _on_timer_timeout() -> void:
	gpu_particles_2d_right.emitting = true
	gpu_particles_2d_left.emitting = true
	if player_in_radius:
		player._take_damage()
	attacking = false
	rest = true
	rest_timer.start()
	




func _on_rest_timer_timeout() -> void:
	rest = false
