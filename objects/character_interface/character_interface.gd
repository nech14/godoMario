extends CanvasLayer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CoinLabel.text = "Coins: %d" % GameState.count_coins
