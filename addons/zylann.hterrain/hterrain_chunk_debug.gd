tool
extends "hterrain_chunk.gd"

const DirectMeshInstance = preload("util/direct_mesh_instance.gd")
const Util = preload("util/util.gd")


var _debug_cube = null
var _aabb = AABB()
var _parent_transform = Transform()


func _init(p_parent, p_cell_x, p_cell_y, p_material).(p_parent, p_cell_x, p_cell_y, p_material):
	var wirecube
	if not p_parent.has_meta("debug_wirecube_mesh"):
		wirecube = Util.create_wirecube_mesh()
		var mat = SpatialMaterial.new()
		mat.flags_unshaded = true
		wirecube.surface_set_material(0, mat)
		p_parent.set_meta("debug_wirecube_mesh", wirecube)
	else:
		wirecube = p_parent.get_meta("debug_wirecube_mesh")

	_debug_cube = DirectMeshInstance.new()
	_debug_cube.set_mesh(wirecube)
	_debug_cube.set_world(p_parent.get_world())


func enter_world(world):
	.enter_world(world)
	_debug_cube.enter_world(world)


func exit_world():
	.exit_world()
	_debug_cube.exit_world()


func parent_transform_changed(parent_transform):
	.parent_transform_changed(parent_transform)
	_parent_transform = parent_transform
	_debug_cube.set_transform(_compute_aabb())


func set_visible(visible):
	.set_visible(visible)
	_debug_cube.set_visible(visible)


func set_aabb(aabb):
	.set_aabb(aabb)
	#aabb.position.y += 0.2*randf()
	_aabb = aabb
	_debug_cube.set_transform(_compute_aabb())


func _compute_aabb():
	var pos = Vector3(cell_origin_x, 0, cell_origin_y)
	return _parent_transform * Transform(Basis().scaled(_aabb.size), pos + _aabb.position)

