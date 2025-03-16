class_name Card extends Node3D

# Components
var model: CardModel
var view: CardView

# Composition
func initialize(model_ref: CardModel, view_scene: PackedScene) -> void:
	model = model_ref
	view = view_scene.instantiate()
	view.initialize_view(model)
	add_child(view)
	
	# Connect signals
	model.logic.playability_changed.connect(view.update_playable_visuals)
	view.drag_started.connect(_on_view_drag_start)
	view.drag_ended.connect(_on_view_drag_end)
	EventBus.card_played.connect(_on_card_played)

func _on_view_drag_start() -> void:
	# Forward to drag system
	EventBus.card_drag_started.emit(self)

func _on_view_drag_end() -> void:
	# Forward to drag system
	EventBus.card_drag_ended.emit(self)

func _on_card_played(card: Card) -> void:
	if card == self:
		view.update_playable_visuals(false)
		view.set_interactable(false)
