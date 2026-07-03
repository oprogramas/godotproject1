extends StaticBody3D

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = int(abs(global_position.x * 137.0 + global_position.z * 251.0))

	# Escala geral da árvore (altura e largura independentes)
	var h := rng.randf_range(0.8, 1.55)
	var w := rng.randf_range(0.75, 1.25)
	scale = Vector3(w, h, w)
	rotation.y = rng.randf_range(0.0, TAU)

	# Randomizar tronco: largura e inclinação
	var trunk_w := rng.randf_range(0.55, 1.7)
	var trunk := $Trunk
	trunk.scale.x = trunk_w
	trunk.scale.z = trunk_w
	trunk.rotation.z = rng.randf_range(-0.13, 0.13)
	trunk.rotation.x = rng.randf_range(-0.09, 0.09)

	# Deslocar clusters de folhagem
	for child in get_children():
		if child.name.begins_with("Cluster"):
			child.position += Vector3(
				rng.randf_range(-0.5, 0.5),
				rng.randf_range(-0.3, 0.3),
				rng.randf_range(-0.5, 0.5)
			)
