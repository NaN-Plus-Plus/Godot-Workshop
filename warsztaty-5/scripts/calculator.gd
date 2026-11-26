extends Control
class_name Calculator


@export var display_label: Label
@export var button_container: GridContainer
@export var history_container: VBoxContainer
@export var key_sound: AudioStreamPlayer

var display_value: int = 0
var stored_value: int = 0
var current_operation: CalculatorButton.OperationEnum = CalculatorButton.OperationEnum.None
var last_input_was_operation: bool = false


func _ready() -> void:
	for button in button_container.get_children() as Array[CalculatorButton]:
		button.on_calculator_button_pressed.connect(on_button_pressed)


func on_button_pressed(function: CalculatorButton.FunctionEnum, operation: CalculatorButton.OperationEnum, value: int) -> void:
	key_sound.pitch_scale = randf() * 0.1 + 0.95
	key_sound.play(0.03)
	
	match function:
		CalculatorButton.FunctionEnum.Number:
			if last_input_was_operation:
				last_input_was_operation = false
				stored_value = display_value
				display_value = value
				display_label.text = str(display_value)
			else:
				display_value *= 10
				display_value += value
				display_label.text = str(display_value)
		
		CalculatorButton.FunctionEnum.Operation:
			if current_operation == CalculatorButton.OperationEnum.None or last_input_was_operation:
				current_operation = operation
			else:
				perform_operation(current_operation)
				current_operation = operation
			
			last_input_was_operation = true
		
		CalculatorButton.FunctionEnum.Equals:
			if current_operation != CalculatorButton.OperationEnum.None:
				perform_operation(current_operation)
				current_operation = CalculatorButton.OperationEnum.None
				
				if history_container.get_child_count() == 9:
					history_container.get_child(8).queue_free()
				
				var label = Label.new()
				label.text = display_label.text
				history_container.add_child(label)
				history_container.move_child(label, 0)
		
		CalculatorButton.FunctionEnum.Clear:
			display_value = 0
			stored_value = 0
			display_label.text = str(display_value)
			last_input_was_operation = false


func perform_operation(operation: CalculatorButton.OperationEnum):
	match operation:
		CalculatorButton.OperationEnum.Sum:
			display_value = stored_value + display_value
		
		CalculatorButton.OperationEnum.Subtraction:
			display_value = stored_value - display_value
		
		CalculatorButton.OperationEnum.Multiplication:
			display_value = stored_value * display_value
		
		CalculatorButton.OperationEnum.Division:
			display_value = stored_value / floor(display_value)
		
	display_label.text = str(display_value)
