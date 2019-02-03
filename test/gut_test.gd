extends 'res://addons/gut/test.gd'

const DOUBLE_ME_PATH = 'res://test/doubler_test_objects/double_me.gd'
var DoubleMe = load(DOUBLE_ME_PATH)

const DOUBLE_ME_SCENE_PATH = 'res://test/doubler_test_objects/double_me_scene.tscn'
var DoubleMeScene = load(DOUBLE_ME_SCENE_PATH)

const DOUBLE_EXTENDS_NODE2D = 'res://test/doubler_test_objects/double_extends_node2d.gd'
var DoubleExtendsNode2D = load(DOUBLE_EXTENDS_NODE2D)

const DOUBLE_EXTENDS_WINDOW_DIALOG = 'res://test/doubler_test_objects/double_extends_window_dialog.gd'
var DoubleExtendsWindowDialog = load(DOUBLE_EXTENDS_WINDOW_DIALOG)

const INNER_CLASSES_PATH = 'res://test/doubler_test_objects/inner_classes.gd'
var InnerClasses = load(INNER_CLASSES_PATH)

var Gut = load('res://addons/gut/gut.gd')
var Test = load('res://addons/gut/test.gd')
