extends CharacterBody3D

const SPEED = 4.0
const MOUSE_SENSITIVITY = 0.002
const HEAD_BOB_FREQ = 1.8
const HEAD_BOB_AMP = 0.05

@onready var camera: Camera3D = $Camera3D
@onready var flashlight: SpotLight3D = $Camera3D/SpotLight3D
@onready var interact_ray: RayCast3D = $Camera3D/InteractRay

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _bob_timer := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI / 2.0, PI / 2.0)

	if event.is_action_pressed("toggle_flashlight"):
		flashlight.visible = not flashlight.visible

	if event.is_action_pressed("interact"):
		_try_interact()

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	move_and_slide()
	_update_head_bob(delta)

func _update_head_bob(delta: float) -> void:
	var moving := is_on_floor() and velocity.length() > 0.5
	if moving:
		_bob_timer = fmod(_bob_timer + delta * HEAD_BOB_FREQ * TAU, TAU)
		camera.position.y = lerp(camera.position.y, 1.7 + sin(_bob_timer) * HEAD_BOB_AMP, delta * 20.0)
	else:
		camera.position.y = lerp(camera.position.y, 1.7, delta * 8.0)

func _try_interact() -> void:
	if interact_ray.is_colliding():
		var collider := interact_ray.get_collider()
		if collider and collider.has_method("collect"):
			collider.collect()
