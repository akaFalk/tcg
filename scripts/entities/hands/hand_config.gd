class_name HandConfig extends Resource

@export_group("Positioning")
@export var screen_margin: float = 0.2            # Margin from screen edge
@export var hand_distance_from_camera: float = 3.2
@export var vertical_offset: float = 0.5          # Vertical offset from base position
@export var flip: int = 180

@export_group("Fan Layout")
@export var fan_angle: float = 30.0               # Total spread angle in degrees
@export var z_spacing: float = 0.01               # Depth spacing between cards
@export var vertical_arc_height: float = 2.0      # Height of the vertical arc

@export_group("Dynamic Radius")
@export var min_radius: float = 1.0
@export var max_radius: float = 3.0
@export var min_cards_for_growth: int = 2
@export var max_cards_for_growth: int = 10

@export_group("Visuals")
@export var card_scale: Vector3 = Vector3(0.5, 0.5, 0.5)
@export var face_rotation_y: float = 0.0          # Y rotation for card facing
@export var show_labels: bool = true
