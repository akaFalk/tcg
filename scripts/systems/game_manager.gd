extends Node3D

var player_deck: Deck
var opponent_deck: Deck
var turn_system: TurnSystem
var player: Player
var opponent: Player

func _ready() -> void:
	initialize_vars()
	start_game()
	turn_system.phase_changed.connect(_on_phase_changed)
	
func initialize_vars() -> void:
	player = get_node("/root/Main/Player")
	opponent = get_node("/root/Main/Opponent")
	player_deck = get_node("/root/Main/Player/Deck")
	opponent_deck = get_node("/root/Main/Opponent/Deck")
	turn_system = get_node("/root/Main/Systems/TurnSystem")

func start_game() -> void:
	player_deck.initialize_deck()
	opponent_deck.initialize_deck()
	deal_initial_cards()

func deal_initial_cards() -> void:
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		player_deck.draw_card()
		
	for i in 5:
		await get_tree().create_timer(0.2).timeout
		opponent_deck.draw_card()

func _on_phase_changed(new_phase: TurnSystem.Phase) -> void:
	match new_phase:
		TurnSystem.Phase.DRAW:
			_draw_card()
		TurnSystem.Phase.MAIN:
			_enable_player_actions(true)
		TurnSystem.Phase.BATTLE:
			_start_battle_phase()
		_:
			_enable_player_actions(false)
			
func _draw_card() -> void:
	if turn_system.current_player == Player.Type.PLAYER:
		player_deck.draw_card()
	else:
		opponent_deck.draw_card()

func _enable_player_actions(_enabled: bool) -> void:
	# Implement UI/input enable/disable
	pass

func _start_battle_phase() -> void:
	# Placeholder for battle logic
	pass
