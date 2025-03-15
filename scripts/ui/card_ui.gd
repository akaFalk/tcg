class_name CardUI extends Node3D

@export var labels: Node3D
@export var name_label: Label3D
@export var cost_label: Label3D
@export var type_label: Label3D
@export var description_label: Label3D
@export var card_image: Sprite3D
@export var card_back: Sprite3D

var target_scale := Vector3.ONE

func update_appearance(data: CardData) -> void:
	card_image.texture = data.image
	name_label.text = data.name
	cost_label.text = str(data.cost)
	type_label.text = data.get_type_as_string()
	description_label.text = data.description

func set_render_priority(priority: int) -> void:
	card_image.render_priority = priority
	card_back.render_priority = priority
	for label in labels.get_children():
		label.render_priority = priority + 1

func animate_hover(active: bool) -> void:
	var target_pos = Vector3.UP * 0.3 if active else Vector3.ZERO
	var target_scale = Vector3(1.1, 1.1, 1.1) if active else Vector3(1, 1, 1)
	
	var tween = create_tween().parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", target_pos, 0.15)
	tween.tween_property(self, "scale", target_scale, 0.15)

func set_labels_visible(visible: bool) -> void:
	for label in labels.get_children():
		label.visible = visible

func set_playable_visuals(playable: bool) -> void:
	card_image.modulate = Color(0.8, 1.0, 0.8) if playable else Color.WHITE
