class_name Card extends Node3D

# Components
var logic: CardLogic
@export var view: CardView

# Composition
func initialize(data: CardData, player_ref: Player) -> void:
	logic = CardLogic.new(data, player_ref)
	
	# Connect signals
	logic.playability_changed.connect(view.update_playable_visuals)
	view.drag_started.connect(_on_drag_start)
	view.drag_ended.connect(_on_drag_end)
	
	# Assumes parent is a CardHoverSystem that connects signals.
	if get_parent() and get_parent().has_method("connect_card_signals"):
		get_parent().connect_card_signals(self)
	
	view.initialize_view(data)

func _on_drag_start() -> void:
	# Forward to drag system
	EventBus.card_drag_started.emit(self)

func _on_drag_end() -> void:
	# Forward to drag system
	EventBus.card_drag_ended.emit(self)

# Proxy methods
func check_playability() -> void:
	logic.check_playability()

func attempt_play() -> bool:
	return logic.attempt_play()

# Positional
#var global_position: Vector3:
	#get: return view.global_position
	#set(value): view.global_position = value
