extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_rope_position(body):
	var newpos
	var shortestdistance
	
	for child in get_children():
		if not child is Sprite2D: continue
		
		var distance = body.global_position.distance_to(child.global_position)
		
		if not shortestdistance ||  distance < shortestdistance:
			newpos = child.global_position
			shortestdistance = distance
			
	return newpos
