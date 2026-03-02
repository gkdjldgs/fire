extends Node2D
@onready var text1 = $Part1/RichTextLabel
@onready var sound = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if autoload.tutorial == 1:
		text1.show()
	if autoload.tutorial == 2:
		text1.hide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	sound.play()
