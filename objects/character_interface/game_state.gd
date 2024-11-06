
extends Node


var count_coins: int = 0
var count_lives: int = 3
var coin_queue: int = 0
var coins_delay = 0.25 

func give_coins(num: int) -> void:
	coin_queue += num
	
	for i in range(coin_queue):
		_handle_coins()
		await get_tree().create_timer(coins_delay).timeout
		


func _handle_coins() -> void:
	
	if coin_queue == 0:
		return 
		
	coin_queue -= 1
	count_coins += 1
	
	

	
