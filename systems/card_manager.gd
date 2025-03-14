extends Node3D
class_name CardManager

const SCREEN_MARGIN: int = 50 # Pixels from screen edge
const COLLISION_MASK_CARD: int = 1
const COLLISION_MASK_CARD_SLOT: int = 2
const RAY_DISTANCE: int = 1000

@export var player_hand: PlayerHand
@export var input_manager: InputManager

var screen_size: Vector2
var card_being_dragged: Card = null
var drag_plane_normal: Vector3 = Vector3.ZERO
var drag_plane_point: Vector3 = Vector3.ZERO

func _ready() -> void:
	screen_size = get_viewport().size
	input_manager.connect("left_mouse_button_released", on_left_mouse_button_released)

func _process(_delta: float) -> void:
	if card_being_dragged:
		update_dragged_card_position()

# --- Drag-and-Drop Positioning ---
func update_dragged_card_position() -> void:
	var viewport: Viewport = get_viewport()
	var mouse_pos: Vector2 = viewport.get_mouse_position()
	var camera: Camera3D = viewport.get_camera_3d()
	if not camera:
		return

	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = camera.project_ray_normal(mouse_pos)
	var denom: float = ray_dir.dot(drag_plane_normal)
	
	if abs(denom) > 1e-6:
		var t: float = (drag_plane_point - ray_origin).dot(drag_plane_normal) / denom
		if t >= 0:
			var target_pos: Vector3 = ray_origin + ray_dir * t
			# Constrain target position by converting to screen and applying margins
			var screen_pos: Vector2 = camera.unproject_position(target_pos)
			var viewport_rect: Rect2 = viewport.get_visible_rect()
			screen_pos.x = clamp(screen_pos.x, viewport_rect.position.x + SCREEN_MARGIN, viewport_rect.end.x - SCREEN_MARGIN)
			screen_pos.y = clamp(screen_pos.y, viewport_rect.position.y + SCREEN_MARGIN, viewport_rect.end.y - SCREEN_MARGIN)
			
			# If clamping changed the position, recalculate world position.
			if screen_pos != mouse_pos:
				ray_origin = camera.project_ray_origin(screen_pos)
				ray_dir = camera.project_ray_normal(screen_pos)
				denom = ray_dir.dot(drag_plane_normal)
				if abs(denom) > 1e-6:
					t = (drag_plane_point - ray_origin).dot(drag_plane_normal) / denom
					if t >= 0:
						target_pos = ray_origin + ray_dir * t
			
			card_being_dragged.position = target_pos

# --- Drag Start and Finish ---
func start_drag(card: Card) -> void:
	card_being_dragged = card
	card.on_start_drag()
	
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera:
		var cam_transform: Transform3D = camera.global_transform
		# Create a plane facing the camera at card's initial position
		drag_plane_normal = cam_transform.basis.z.normalized()
		drag_plane_point = card.position
		
func finish_drag() -> void:
	var card_slot_found: CardSlot = raycast_check_for_collision(get_viewport().get_mouse_position(), COLLISION_MASK_CARD_SLOT)
	
	# Return back to normal render priority
	card_being_dragged.on_finish_drag()
	if card_slot_found and card_slot_found.accepts_card_type(card_being_dragged):
		# Card dropped in empty card slot
		card_slot_found.add_card(card_being_dragged)
		player_hand.remove_card_from_hand(card_being_dragged)
	else:
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(card_being_dragged, "position", card_being_dragged.hand_position, 0.15)
		tween.tween_property(card_being_dragged, "rotation_degrees", card_being_dragged.target_rotation, 0.15)
		tween.tween_property(card_being_dragged, "scale", Vector3(0.5, 0.5, 0.5), 0.15)
	
	card_being_dragged = null

# --- Input and Signal Handling ---
func on_left_mouse_button_released() -> void:
	if card_being_dragged:
		finish_drag()

func on_hovered_over_card(card: Card) -> void:
	if !card_being_dragged and card in player_hand.cards:
		card.on_hover()

func on_hovered_off_card(card: Card) -> void:
	if !card_being_dragged and card in player_hand.cards:
		card.on_hover_off()

func connect_card_signals(card: Card) -> void:
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

# --- Raycast for Collision Detection ---
func raycast_check_for_collision(mouse_position: Vector2, collision_mask: int) -> Node:
	var camera = get_viewport().get_camera_3d()
	if camera:
		var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
		var ray_dir: Vector3 = camera.project_ray_normal(mouse_position)
		var from = ray_origin
		var to = from + ray_dir * RAY_DISTANCE
		
		var params: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
		params.collide_with_areas = true
		params.collision_mask = collision_mask
		
		var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(params)
		if result:
			return result.collider.get_parent()
		
	return null
