extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVars.number_keys = 9999
	$Score.text = str(GlobalVars.score)
	$Deaths.text = str(GlobalVars.deaths_n)
	$Diamonds.text = str(GlobalVars.number_blue_diamonds.length() + GlobalVars.number_green_diamonds.length() + GlobalVars.number_red_diamonds.length())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
