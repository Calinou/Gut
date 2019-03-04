extends Node2D

onready var _script_list = $Main/ScriptsList
onready var _nav = {
	prev = $Main/Navigation/Previous,
	next = $Main/Navigation/Next,
	run = $Main/Navigation/Run,
	current_script = $Main/Navigation/CurrentScript,
	show_scripts = $Main/Navigation/ShowScripts
}
onready var _progress = {
	script = $Main/ScriptProgress,
	test = $Main/TestProgress
}

var _mouse = {
	down = false,
	in_title = false,
	down_pos = null
}

signal run_script
signal run_single_script
signal log_level_changed
signal script_selected
signal end_pause
signal ignore_pause

func _ready():
	_hide_scripts()
	_update_controls()
	_nav.current_script.set_text("No scripts available")

# ####################
# GUI Events
# ####################
func _on_Run_pressed():
	_run_mode()
	emit_signal('run_script', get_selected_index())

func _on_CurrentScript_pressed():
	_run_mode()
	emit_signal('run_single_script', get_selected_index())

func _on_Previous_pressed():
	_select_script(get_selected_index() - 1)

func _on_Next_pressed():
	_select_script(get_selected_index() + 1)

func _on_LogLevelSlider_value_changed(value):
	emit_signal('log_level_changed', $Main/LogLevelSlider.value)

func _on_Continue_pressed():
	emit_signal('end_pause')
	$Main/Continue/Continue.disabled = true

func _on_CheckBox_pressed():
	var checked = $Main/Continue/CheckBox.is_pressed()
	emit_signal('ignore_pause', checked)
	if(checked):
		$Main/Continue/Continue.disabled = true

func _on_ShowScripts_pressed():
	_toggle_scripts()

func _on_ScriptsList_item_selected(index):
	_select_script(index)

func _on_TitleBar_mouse_entered():
	_mouse.in_title = true

func _on_TitleBar_mouse_exited():
	_mouse.in_title = false

func _input(event):
	if(event is InputEventMouseButton):
		if(event.button_index == 1):
			_mouse.down = event.pressed
			if(_mouse.down):
				_mouse.down_pos = event.position

	if(_mouse.in_title):
		if(event is InputEventMouseMotion and _mouse.down):
			position = position + (event.position - _mouse.down_pos)
			_mouse.down_pos = event.position

	# # if the mouse is somewhere within the debug window
	# if(_mouse_in):
	# 	# Check for mouse click inside the resize handle
	# 	if(event is InputEventMouseButton):
	# 		if (event.button_index == 1):
	# 			# It's checking a square area for the bottom right corner, but that's close enough.  I'm lazy
	# 			if(event.position.x > get_size().x + get_position().x - 10 and event.position.y > get_size().y + get_position().y - 10):
	# 				if event.pressed:
	# 					_mouse_down = true
	# 					_mouse_down_pos = event.position
	# 				else:
	# 					_mouse_down = false
	# 	# Reszie
	# 	if(event is InputEventMouseMotion):
	# 		if(_mouse_down):
	# 			if(get_size() >= min_size):
	# 				var new_size = get_size() + event.position - _mouse_down_pos
	# 				var new_mouse_down_pos = event.position
	#
	# 				if(new_size.x < min_size.x):
	# 					new_size.x = min_size.x
	# 					new_mouse_down_pos.x = _mouse_down_pos.x
	#
	# 				if(new_size.y < min_size.y):
	# 					new_size.y = min_size.y
	# 					new_mouse_down_pos.y = _mouse_down_pos.y
	#
	# 				_mouse_down_pos = new_mouse_down_pos
	# 				set_size(new_size)


# ####################
# Private
# ####################
func _run_mode(is_running=true):
	_hide_scripts()
	var ctrls = $Main/Navigation.get_children()
	for i in range(ctrls.size()):
		ctrls[i].disabled = is_running

func _select_script(index):
	$Main/Navigation/CurrentScript.set_text(_script_list.get_item_text(index))
	_script_list.select(index)
	_update_controls()

func _toggle_scripts():
	if(_script_list.visible):
		_hide_scripts()
	else:
		_show_scripts()

func _show_scripts():
	_script_list.show()

func _hide_scripts():
	_script_list.hide()

func _update_controls():
	var is_empty = _script_list.get_selected_items().size() == 0
	if(is_empty):
		_nav.next.disabled = true
		_nav.prev.disabled = true
	else:
		var index = get_selected_index()
		_nav.prev.disabled = index <= 0
		_nav.next.disabled = index >= _script_list.get_item_count() - 1

	_nav.run.disabled = is_empty
	_nav.current_script.disabled = is_empty
	_nav.show_scripts.disabled = is_empty


# ####################
# Public
# ####################
func set_scripts(scripts):
	_script_list.clear()
	for i in range(scripts.size()):
		_script_list.add_item(scripts[i])
	_select_script(0)
	_update_controls()

func select_script(index):
	_select_script(index)

func get_selected_index():
	return _script_list.get_selected_items()[0]

func get_log_level():
	pass

func set_log_level():
	pass

func get_rich_text_label():
	return $Main/TextDisplay/RichTextLabel

func end_run():
	_run_mode(false)
	_update_controls()

func set_progress_script_max(value):
	_progress.script.set_max(value)

func set_progress_script_value(value):
	_progress.script.set_value(value)

func set_progress_test_max(value):
	_progress.test.set_max(value)

func set_progress_test_value(value):
	_progress.test.set_value(value)

func clear_progress():
	_progress.test.set_value(0)
	_progress.script.set_value(0)
	
func pause():
	$Main/Continue/Continue.disabled = false
