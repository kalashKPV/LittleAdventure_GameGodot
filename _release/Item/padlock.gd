extends AnimatedSprite2D


@export var number_keys : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVars.number_keys >= number_keys:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalVars.number_keys >= number_keys:
		$".".play("Open")
		await get_tree().create_timer(0.7).timeout
		queue_free()
