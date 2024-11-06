
extends Node


var count_coins: int = 0
var count_lives: int = 3


func give_coins(num: int) -> void:
	count_coins += num
