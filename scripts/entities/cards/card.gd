class_name Card extends Node3D

# --- UI Nodes ---
@export var name_label: Label3D
@export var cost_label: Label3D
@export var type_label: Label3D
@export var description_label: Label3D

@export var card_image_sprite: Sprite3D
@export var card_back_image_sprite: Sprite3D

# --- Signals ---
signal hovered
signal hovered_off

# --- Rendering & Positioning ---
var hand_render: int = 0
var hand_position: Vector3 = Vector3.ZERO
var target_rotation: Vector3 = Vector3.ZERO

# --- Card Data ---
var card_data: CardData : set = set_card_data
var player: PlayerData.Type

var is_playable: bool = false :
	set(value):
		is_playable = value
		_update_playable_visuals()

func _ready() -> void:
	# Assumes parent is a CardManager (or similar) that connects signals.
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
func set_card_data(data: CardData) -> void:
	card_data = data
	
	# Set default render
	update_render_priority(0)
	
	# UI elements
	card_image_sprite.texture = card_data.image
	
	name_label.text = card_data.name
	cost_label.text = str(card_data.cost)
	type_label.text = card_data.get_type_as_string()
	description_label.text = card_data.description
	
	print("Initialized card: " + card_data.name)

# --- Render Priority ---
func update_render_priority(priority: int) -> void:
	hand_render = priority * 2
	update_card_render(hand_render)

func update_card_render(priority: int) -> void:
	card_image_sprite.render_priority = priority
	card_back_image_sprite.render_priority = priority
	name_label.render_priority = priority + 1
	cost_label.render_priority = priority + 1
	type_label.render_priority = priority + 1
	description_label.render_priority = priority + 1

# --- Hover and Drag Interactions ---
func on_hover() -> void:
	position = Vector3(
		hand_position.x, 
		hand_position.y + 0.30, 
		hand_position.z
	)
	
	scale = Vector3(0.6, 0.6, 0.6)
	
func on_hover_off() -> void:
	position = hand_position
	scale = Vector3(0.5, 0.5, 0.5)
	update_card_render(hand_render)
	
func on_start_drag() -> void:
	update_card_render(100)
	rotation_degrees.z = 0
	scale = Vector3(0.5, 0.5, 0.5)

func on_finish_drag() -> void:
	update_card_render(hand_render)

func set_labels_visible(show_labels: bool) -> void:
	name_label.visible = show_labels
	cost_label.visible = show_labels
	type_label.visible = show_labels
	description_label.visible = show_labels

func _update_playable_visuals():
	if is_playable:
		card_image_sprite.modulate = Color(0.8, 1.0, 0.8)  # Green tint
	else:
		card_image_sprite.modulate = Color.WHITE

func check_playability(player_data: PlayerData) -> void:
	is_playable = CardValidator.validate(self, player_data)

func attempt_play() -> bool:
	if !is_playable:
		return false
		
	if player == PlayerData.Type.PLAYER:
		GameManager.player_data.spend_resources(card_data.cost)
	else:
		GameManager.opponent_data.spend_resources(card_data.cost)
	
	play()
	return true

# --- Default Card Behavior ---
func play() -> void:
	print("Playing card: " + card_data.name)
	# Override in child classes for type-specific behavior.
