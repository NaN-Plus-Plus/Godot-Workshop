extends TextureButton
class_name CalculatorButton


enum FunctionEnum {
	Number,
	Operation,
	Equals,
	Clear
}

enum OperationEnum {
	Sum,
	Subtraction,
	Multiplication,
	Division,
	None
}

signal on_calculator_button_pressed(function, operation, value)

@export var function: FunctionEnum
@export var operation: CalculatorButton.OperationEnum
@export_range(0, 9) var value: int


func _ready() -> void:
	pressed.connect(func(): on_calculator_button_pressed.emit(function, operation, value))


#func on_pressed():
	#on_calculator_button_pressed.emit(function, operation, value)
