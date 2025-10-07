extends AudioStreamPlayer

func _ready() -> void:
	play()  # Начать воспроизведение музыки

func _process(delta: float) -> void:
	volume_db = map_range(GlobalVars.sound, 0, 100, -50, -10)

func _on_finished() -> void:
	play()

func map_range(value: float, min1: float, max1: float, min2: float, max2: float) -> float:
	return min2 + (value - min1) * (max2 - min2) / (max1 - min1)
