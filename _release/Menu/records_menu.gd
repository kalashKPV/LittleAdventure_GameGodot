extends Node2D

func _ready() -> void:
	$HiRecord.text = str(GlobalVars.hi_score)
