class_name Card extends Node3D

@export var _ui: CardUI
@export var _collision_shape: CollisionShape3D

# --- Signals ---
signal hovered
signal hovered_off

# --- Rendering & Positioning ---
var hand_render: int = 0
var hand_position: Vector3 = Vector3.ZERO
var target_rotation: Vector3 = Vector3.ZERO

# --- Card Data ---
var card_data: CardData
var player: Player

var is_playable: bool = false :
	set(value):
		is_playable = value
		_ui.set_playable_visuals(value)

func _ready() -> void:
	# Assumes parent is a CardHoverSystem that connects signals.
	if get_parent() and get_parent().has_method("connect_card_signals"):
		get_parent().connect_card_signals(self)
	else:
		push_warning("Parent node does not have 'connect_card_signals' method.")

# --- Mouse Interaction ---
func _on_area_3d_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_area_3d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

# --- Initialization via CardData ---
func initialize(data: CardData) -> void:
	card_data = data
	_ui.update_appearance(data)
	_ui.set_labels_visible(false)
	interactable(false)
	
func show_card(show_card: bool) -> void:
	_ui.set_labels_visible(show_card)

# --- Render Priority ---
func update_render_priority(priority: int) -> void:
	hand_render = priority * 2
	_ui.set_render_priority(hand_render)

# --- Hover and Drag Interactions ---
func on_hover() -> void:
	_ui.animate_hover(true)
	
func on_hover_off() -> void:
	_ui.animate_hover(false)
	_ui.set_render_priority(hand_render)
	
func on_start_drag() -> void:
	_ui.set_render_priority(100)
	rotation_degrees.z = 0

func on_finish_drag() -> void:
	_ui.set_render_priority(hand_render)
	
func interactable(value: bool) -> void:
	_collision_shape.disabled = !value

func check_playability() -> void:
	var conditions = card_data.get_play_conditions()
	is_playable
	
	for condition in conditions:
		if not condition.validate(self):
			is_playable = false
			return
	
	is_playable = true

func attempt_play() -> bool:
	if !is_playable:
		return false
		
	_ui.set_render_priority(0)
	_ui.animate_hover(false)
	is_playable = false
	interactable(false)
	
	play()
	return true

# --- Default Card Behavior ---
func play() -> void:
	print("Playing card: " + card_data.name)
	# Override in child classes for type-specific behavior.
