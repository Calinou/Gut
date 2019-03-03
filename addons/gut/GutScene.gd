extends Node2D

onready var _script_list = $Main/ScriptsList
onready var _nav = {
	prev = $Main/Navigation/Previous,
	next = $Main/Navigation/Next
}

signal run_script
signal run_single_script
signal log_level_changed
signal script_selected
signal end_pause
signal ignore_pause

func _ready():
	_hide_scripts()

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
	pass # replace with function body

func _on_CheckBox_pressed():
	pass # replace with function body

func _on_ShowScripts_pressed():
	_toggle_scripts()
	
func _on_ScriptsList_item_selected(index):
	_select_script(index)


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
	if(_script_list.get_selected_items().size() == 0):
		_nav.next.disabled = true
		_nav.prev.disabled = true
	else:
		var index = get_selected_index()
		_nav.prev.disabled = index <= 0
		_nav.next.disabled = index >= _script_list.get_item_count() - 1

# ####################
# Public
# ####################
func set_scripts(scripts):
	_script_list.clear()
	for i in range(scripts.size()):
		_script_list.add_item(scripts[i])
	_select_script(0)
		
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