@tool

extends StaticBody3D

@onready var mesh_instance = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D

# For each MC case, a list of triangles, specified as triples of edge indices, terminated by -1
var triangle_table = [
	[ -1 ],
	[ 0, 3, 8, -1 ],
	[ 0, 9, 1, -1 ],
	[ 3, 8, 1, 1, 8, 9, -1 ],
	[ 2, 11, 3, -1 ],
	[ 8, 0, 11, 11, 0, 2, -1 ],
	[ 3, 2, 11, 1, 0, 9, -1 ],
	[ 11, 1, 2, 11, 9, 1, 11, 8, 9, -1 ],
	[ 1, 10, 2, -1 ],
	[ 0, 3, 8, 2, 1, 10, -1 ],
	[ 10, 2, 9, 9, 2, 0, -1 ],
	[ 8, 2, 3, 8, 10, 2, 8, 9, 10, -1 ],
	[ 11, 3, 10, 10, 3, 1, -1 ],
	[ 10, 0, 1, 10, 8, 0, 10, 11, 8, -1 ],
	[ 9, 3, 0, 9, 11, 3, 9, 10, 11, -1 ],
	[ 8, 9, 11, 11, 9, 10, -1 ],
	[ 4, 8, 7, -1 ],
	[ 7, 4, 3, 3, 4, 0, -1 ],
	[ 4, 8, 7, 0, 9, 1, -1 ],
	[ 1, 4, 9, 1, 7, 4, 1, 3, 7, -1 ],
	[ 8, 7, 4, 11, 3, 2, -1 ],
	[ 4, 11, 7, 4, 2, 11, 4, 0, 2, -1 ],
	[ 0, 9, 1, 8, 7, 4, 11, 3, 2, -1 ],
	[ 7, 4, 11, 11, 4, 2, 2, 4, 9, 2, 9, 1, -1 ],
	[ 4, 8, 7, 2, 1, 10, -1 ],
	[ 7, 4, 3, 3, 4, 0, 10, 2, 1, -1 ],
	[ 10, 2, 9, 9, 2, 0, 7, 4, 8, -1 ],
	[ 10, 2, 3, 10, 3, 4, 3, 7, 4, 9, 10, 4, -1 ],
	[ 1, 10, 3, 3, 10, 11, 4, 8, 7, -1 ],
	[ 10, 11, 1, 11, 7, 4, 1, 11, 4, 1, 4, 0, -1 ],
	[ 7, 4, 8, 9, 3, 0, 9, 11, 3, 9, 10, 11, -1 ],
	[ 7, 4, 11, 4, 9, 11, 9, 10, 11, -1 ],
	[ 9, 4, 5, -1 ],
	[ 9, 4, 5, 8, 0, 3, -1 ],
	[ 4, 5, 0, 0, 5, 1, -1 ],
	[ 5, 8, 4, 5, 3, 8, 5, 1, 3, -1 ],
	[ 9, 4, 5, 11, 3, 2, -1 ],
	[ 2, 11, 0, 0, 11, 8, 5, 9, 4, -1 ],
	[ 4, 5, 0, 0, 5, 1, 11, 3, 2, -1 ],
	[ 5, 1, 4, 1, 2, 11, 4, 1, 11, 4, 11, 8, -1 ],
	[ 1, 10, 2, 5, 9, 4, -1 ],
	[ 9, 4, 5, 0, 3, 8, 2, 1, 10, -1 ],
	[ 2, 5, 10, 2, 4, 5, 2, 0, 4, -1 ],
	[ 10, 2, 5, 5, 2, 4, 4, 2, 3, 4, 3, 8, -1 ],
	[ 11, 3, 10, 10, 3, 1, 4, 5, 9, -1 ],
	[ 4, 5, 9, 10, 0, 1, 10, 8, 0, 10, 11, 8, -1 ],
	[ 11, 3, 0, 11, 0, 5, 0, 4, 5, 10, 11, 5, -1 ],
	[ 4, 5, 8, 5, 10, 8, 10, 11, 8, -1 ],
	[ 8, 7, 9, 9, 7, 5, -1 ],
	[ 3, 9, 0, 3, 5, 9, 3, 7, 5, -1 ],
	[ 7, 0, 8, 7, 1, 0, 7, 5, 1, -1 ],
	[ 7, 5, 3, 3, 5, 1, -1 ],
	[ 5, 9, 7, 7, 9, 8, 2, 11, 3, -1 ],
	[ 2, 11, 7, 2, 7, 9, 7, 5, 9, 0, 2, 9, -1 ],
	[ 2, 11, 3, 7, 0, 8, 7, 1, 0, 7, 5, 1, -1 ],
	[ 2, 11, 1, 11, 7, 1, 7, 5, 1, -1 ],
	[ 8, 7, 9, 9, 7, 5, 2, 1, 10, -1 ],
	[ 10, 2, 1, 3, 9, 0, 3, 5, 9, 3, 7, 5, -1 ],
	[ 7, 5, 8, 5, 10, 2, 8, 5, 2, 8, 2, 0, -1 ],
	[ 10, 2, 5, 2, 3, 5, 3, 7, 5, -1 ],
	[ 8, 7, 5, 8, 5, 9, 11, 3, 10, 3, 1, 10, -1 ],
	[ 5, 11, 7, 10, 11, 5, 1, 9, 0, -1 ],
	[ 11, 5, 10, 7, 5, 11, 8, 3, 0, -1 ],
	[ 5, 11, 7, 10, 11, 5, -1 ],
	[ 6, 7, 11, -1 ],
	[ 7, 11, 6, 3, 8, 0, -1 ],
	[ 6, 7, 11, 0, 9, 1, -1 ],
	[ 9, 1, 8, 8, 1, 3, 6, 7, 11, -1 ],
	[ 3, 2, 7, 7, 2, 6, -1 ],
	[ 0, 7, 8, 0, 6, 7, 0, 2, 6, -1 ],
	[ 6, 7, 2, 2, 7, 3, 9, 1, 0, -1 ],
	[ 6, 7, 8, 6, 8, 1, 8, 9, 1, 2, 6, 1, -1 ],
	[ 11, 6, 7, 10, 2, 1, -1 ],
	[ 3, 8, 0, 11, 6, 7, 10, 2, 1, -1 ],
	[ 0, 9, 2, 2, 9, 10, 7, 11, 6, -1 ],
	[ 6, 7, 11, 8, 2, 3, 8, 10, 2, 8, 9, 10, -1 ],
	[ 7, 10, 6, 7, 1, 10, 7, 3, 1, -1 ],
	[ 8, 0, 7, 7, 0, 6, 6, 0, 1, 6, 1, 10, -1 ],
	[ 7, 3, 6, 3, 0, 9, 6, 3, 9, 6, 9, 10, -1 ],
	[ 6, 7, 10, 7, 8, 10, 8, 9, 10, -1 ],
	[ 11, 6, 8, 8, 6, 4, -1 ],
	[ 6, 3, 11, 6, 0, 3, 6, 4, 0, -1 ],
	[ 11, 6, 8, 8, 6, 4, 1, 0, 9, -1 ],
	[ 1, 3, 9, 3, 11, 6, 9, 3, 6, 9, 6, 4, -1 ],
	[ 2, 8, 3, 2, 4, 8, 2, 6, 4, -1 ],
	[ 4, 0, 6, 6, 0, 2, -1 ],
	[ 9, 1, 0, 2, 8, 3, 2, 4, 8, 2, 6, 4, -1 ],
	[ 9, 1, 4, 1, 2, 4, 2, 6, 4, -1 ],
	[ 4, 8, 6, 6, 8, 11, 1, 10, 2, -1 ],
	[ 1, 10, 2, 6, 3, 11, 6, 0, 3, 6, 4, 0, -1 ],
	[ 11, 6, 4, 11, 4, 8, 10, 2, 9, 2, 0, 9, -1 ],
	[ 10, 4, 9, 6, 4, 10, 11, 2, 3, -1 ],
	[ 4, 8, 3, 4, 3, 10, 3, 1, 10, 6, 4, 10, -1 ],
	[ 1, 10, 0, 10, 6, 0, 6, 4, 0, -1 ],
	[ 4, 10, 6, 9, 10, 4, 0, 8, 3, -1 ],
	[ 4, 10, 6, 9, 10, 4, -1 ],
	[ 6, 7, 11, 4, 5, 9, -1 ],
	[ 4, 5, 9, 7, 11, 6, 3, 8, 0, -1 ],
	[ 1, 0, 5, 5, 0, 4, 11, 6, 7, -1 ],
	[ 11, 6, 7, 5, 8, 4, 5, 3, 8, 5, 1, 3, -1 ],
	[ 3, 2, 7, 7, 2, 6, 9, 4, 5, -1 ],
	[ 5, 9, 4, 0, 7, 8, 0, 6, 7, 0, 2, 6, -1 ],
	[ 3, 2, 6, 3, 6, 7, 1, 0, 5, 0, 4, 5, -1 ],
	[ 6, 1, 2, 5, 1, 6, 4, 7, 8, -1 ],
	[ 10, 2, 1, 6, 7, 11, 4, 5, 9, -1 ],
	[ 0, 3, 8, 4, 5, 9, 11, 6, 7, 10, 2, 1, -1 ],
	[ 7, 11, 6, 2, 5, 10, 2, 4, 5, 2, 0, 4, -1 ],
	[ 8, 4, 7, 5, 10, 6, 3, 11, 2, -1 ],
	[ 9, 4, 5, 7, 10, 6, 7, 1, 10, 7, 3, 1, -1 ],
	[ 10, 6, 5, 7, 8, 4, 1, 9, 0, -1 ],
	[ 4, 3, 0, 7, 3, 4, 6, 5, 10, -1 ],
	[ 10, 6, 5, 8, 4, 7, -1 ],
	[ 9, 6, 5, 9, 11, 6, 9, 8, 11, -1 ],
	[ 11, 6, 3, 3, 6, 0, 0, 6, 5, 0, 5, 9, -1 ],
	[ 11, 6, 5, 11, 5, 0, 5, 1, 0, 8, 11, 0, -1 ],
	[ 11, 6, 3, 6, 5, 3, 5, 1, 3, -1 ],
	[ 9, 8, 5, 8, 3, 2, 5, 8, 2, 5, 2, 6, -1 ],
	[ 5, 9, 6, 9, 0, 6, 0, 2, 6, -1 ],
	[ 1, 6, 5, 2, 6, 1, 3, 0, 8, -1 ],
	[ 1, 6, 5, 2, 6, 1, -1 ],
	[ 2, 1, 10, 9, 6, 5, 9, 11, 6, 9, 8, 11, -1 ],
	[ 9, 0, 1, 3, 11, 2, 5, 10, 6, -1 ],
	[ 11, 0, 8, 2, 0, 11, 10, 6, 5, -1 ],
	[ 3, 11, 2, 5, 10, 6, -1 ],
	[ 1, 8, 3, 9, 8, 1, 5, 10, 6, -1 ],
	[ 6, 5, 10, 0, 1, 9, -1 ],
	[ 8, 3, 0, 5, 10, 6, -1 ],
	[ 6, 5, 10, -1 ],
	[ 10, 5, 6, -1 ],
	[ 0, 3, 8, 6, 10, 5, -1 ],
	[ 10, 5, 6, 9, 1, 0, -1 ],
	[ 3, 8, 1, 1, 8, 9, 6, 10, 5, -1 ],
	[ 2, 11, 3, 6, 10, 5, -1 ],
	[ 8, 0, 11, 11, 0, 2, 5, 6, 10, -1 ],
	[ 1, 0, 9, 2, 11, 3, 6, 10, 5, -1 ],
	[ 5, 6, 10, 11, 1, 2, 11, 9, 1, 11, 8, 9, -1 ],
	[ 5, 6, 1, 1, 6, 2, -1 ],
	[ 5, 6, 1, 1, 6, 2, 8, 0, 3, -1 ],
	[ 6, 9, 5, 6, 0, 9, 6, 2, 0, -1 ],
	[ 6, 2, 5, 2, 3, 8, 5, 2, 8, 5, 8, 9, -1 ],
	[ 3, 6, 11, 3, 5, 6, 3, 1, 5, -1 ],
	[ 8, 0, 1, 8, 1, 6, 1, 5, 6, 11, 8, 6, -1 ],
	[ 11, 3, 6, 6, 3, 5, 5, 3, 0, 5, 0, 9, -1 ],
	[ 5, 6, 9, 6, 11, 9, 11, 8, 9, -1 ],
	[ 5, 6, 10, 7, 4, 8, -1 ],
	[ 0, 3, 4, 4, 3, 7, 10, 5, 6, -1 ],
	[ 5, 6, 10, 4, 8, 7, 0, 9, 1, -1 ],
	[ 6, 10, 5, 1, 4, 9, 1, 7, 4, 1, 3, 7, -1 ],
	[ 7, 4, 8, 6, 10, 5, 2, 11, 3, -1 ],
	[ 10, 5, 6, 4, 11, 7, 4, 2, 11, 4, 0, 2, -1 ],
	[ 4, 8, 7, 6, 10, 5, 3, 2, 11, 1, 0, 9, -1 ],
	[ 1, 2, 10, 11, 7, 6, 9, 5, 4, -1 ],
	[ 2, 1, 6, 6, 1, 5, 8, 7, 4, -1 ],
	[ 0, 3, 7, 0, 7, 4, 2, 1, 6, 1, 5, 6, -1 ],
	[ 8, 7, 4, 6, 9, 5, 6, 0, 9, 6, 2, 0, -1 ],
	[ 7, 2, 3, 6, 2, 7, 5, 4, 9, -1 ],
	[ 4, 8, 7, 3, 6, 11, 3, 5, 6, 3, 1, 5, -1 ],
	[ 5, 0, 1, 4, 0, 5, 7, 6, 11, -1 ],
	[ 9, 5, 4, 6, 11, 7, 0, 8, 3, -1 ],
	[ 11, 7, 6, 9, 5, 4, -1 ],
	[ 6, 10, 4, 4, 10, 9, -1 ],
	[ 6, 10, 4, 4, 10, 9, 3, 8, 0, -1 ],
	[ 0, 10, 1, 0, 6, 10, 0, 4, 6, -1 ],
	[ 6, 10, 1, 6, 1, 8, 1, 3, 8, 4, 6, 8, -1 ],
	[ 9, 4, 10, 10, 4, 6, 3, 2, 11, -1 ],
	[ 2, 11, 8, 2, 8, 0, 6, 10, 4, 10, 9, 4, -1 ],
	[ 11, 3, 2, 0, 10, 1, 0, 6, 10, 0, 4, 6, -1 ],
	[ 6, 8, 4, 11, 8, 6, 2, 10, 1, -1 ],
	[ 4, 1, 9, 4, 2, 1, 4, 6, 2, -1 ],
	[ 3, 8, 0, 4, 1, 9, 4, 2, 1, 4, 6, 2, -1 ],
	[ 6, 2, 4, 4, 2, 0, -1 ],
	[ 3, 8, 2, 8, 4, 2, 4, 6, 2, -1 ],
	[ 4, 6, 9, 6, 11, 3, 9, 6, 3, 9, 3, 1, -1 ],
	[ 8, 6, 11, 4, 6, 8, 9, 0, 1, -1 ],
	[ 11, 3, 6, 3, 0, 6, 0, 4, 6, -1 ],
	[ 8, 6, 11, 4, 6, 8, -1 ],
	[ 10, 7, 6, 10, 8, 7, 10, 9, 8, -1 ],
	[ 3, 7, 0, 7, 6, 10, 0, 7, 10, 0, 10, 9, -1 ],
	[ 6, 10, 7, 7, 10, 8, 8, 10, 1, 8, 1, 0, -1 ],
	[ 6, 10, 7, 10, 1, 7, 1, 3, 7, -1 ],
	[ 3, 2, 11, 10, 7, 6, 10, 8, 7, 10, 9, 8, -1 ],
	[ 2, 9, 0, 10, 9, 2, 6, 11, 7, -1 ],
	[ 0, 8, 3, 7, 6, 11, 1, 2, 10, -1 ],
	[ 7, 6, 11, 1, 2, 10, -1 ],
	[ 2, 1, 9, 2, 9, 7, 9, 8, 7, 6, 2, 7, -1 ],
	[ 2, 7, 6, 3, 7, 2, 0, 1, 9, -1 ],
	[ 8, 7, 0, 7, 6, 0, 6, 2, 0, -1 ],
	[ 7, 2, 3, 6, 2, 7, -1 ],
	[ 8, 1, 9, 3, 1, 8, 11, 7, 6, -1 ],
	[ 11, 7, 6, 1, 9, 0, -1 ],
	[ 6, 11, 7, 0, 8, 3, -1 ],
	[ 11, 7, 6, -1 ],
	[ 7, 11, 5, 5, 11, 10, -1 ],
	[ 10, 5, 11, 11, 5, 7, 0, 3, 8, -1 ],
	[ 7, 11, 5, 5, 11, 10, 0, 9, 1, -1 ],
	[ 7, 11, 10, 7, 10, 5, 3, 8, 1, 8, 9, 1, -1 ],
	[ 5, 2, 10, 5, 3, 2, 5, 7, 3, -1 ],
	[ 5, 7, 10, 7, 8, 0, 10, 7, 0, 10, 0, 2, -1 ],
	[ 0, 9, 1, 5, 2, 10, 5, 3, 2, 5, 7, 3, -1 ],
	[ 9, 7, 8, 5, 7, 9, 10, 1, 2, -1 ],
	[ 1, 11, 2, 1, 7, 11, 1, 5, 7, -1 ],
	[ 8, 0, 3, 1, 11, 2, 1, 7, 11, 1, 5, 7, -1 ],
	[ 7, 11, 2, 7, 2, 9, 2, 0, 9, 5, 7, 9, -1 ],
	[ 7, 9, 5, 8, 9, 7, 3, 11, 2, -1 ],
	[ 3, 1, 7, 7, 1, 5, -1 ],
	[ 8, 0, 7, 0, 1, 7, 1, 5, 7, -1 ],
	[ 0, 9, 3, 9, 5, 3, 5, 7, 3, -1 ],
	[ 9, 7, 8, 5, 7, 9, -1 ],
	[ 8, 5, 4, 8, 10, 5, 8, 11, 10, -1 ],
	[ 0, 3, 11, 0, 11, 5, 11, 10, 5, 4, 0, 5, -1 ],
	[ 1, 0, 9, 8, 5, 4, 8, 10, 5, 8, 11, 10, -1 ],
	[ 10, 3, 11, 1, 3, 10, 9, 5, 4, -1 ],
	[ 3, 2, 8, 8, 2, 4, 4, 2, 10, 4, 10, 5, -1 ],
	[ 10, 5, 2, 5, 4, 2, 4, 0, 2, -1 ],
	[ 5, 4, 9, 8, 3, 0, 10, 1, 2, -1 ],
	[ 2, 10, 1, 4, 9, 5, -1 ],
	[ 8, 11, 4, 11, 2, 1, 4, 11, 1, 4, 1, 5, -1 ],
	[ 0, 5, 4, 1, 5, 0, 2, 3, 11, -1 ],
	[ 0, 11, 2, 8, 11, 0, 4, 9, 5, -1 ],
	[ 5, 4, 9, 2, 3, 11, -1 ],
	[ 4, 8, 5, 8, 3, 5, 3, 1, 5, -1 ],
	[ 0, 5, 4, 1, 5, 0, -1 ],
	[ 5, 4, 9, 3, 0, 8, -1 ],
	[ 5, 4, 9, -1 ],
	[ 11, 4, 7, 11, 9, 4, 11, 10, 9, -1 ],
	[ 0, 3, 8, 11, 4, 7, 11, 9, 4, 11, 10, 9, -1 ],
	[ 11, 10, 7, 10, 1, 0, 7, 10, 0, 7, 0, 4, -1 ],
	[ 3, 10, 1, 11, 10, 3, 7, 8, 4, -1 ],
	[ 3, 2, 10, 3, 10, 4, 10, 9, 4, 7, 3, 4, -1 ],
	[ 9, 2, 10, 0, 2, 9, 8, 4, 7, -1 ],
	[ 3, 4, 7, 0, 4, 3, 1, 2, 10, -1 ],
	[ 7, 8, 4, 10, 1, 2, -1 ],
	[ 7, 11, 4, 4, 11, 9, 9, 11, 2, 9, 2, 1, -1 ],
	[ 1, 9, 0, 4, 7, 8, 2, 3, 11, -1 ],
	[ 7, 11, 4, 11, 2, 4, 2, 0, 4, -1 ],
	[ 4, 7, 8, 2, 3, 11, -1 ],
	[ 9, 4, 1, 4, 7, 1, 7, 3, 1, -1 ],
	[ 7, 8, 4, 1, 9, 0, -1 ],
	[ 3, 4, 7, 0, 4, 3, -1 ],
	[ 7, 8, 4, -1 ],
	[ 11, 10, 8, 8, 10, 9, -1 ],
	[ 0, 3, 9, 3, 11, 9, 11, 10, 9, -1 ],
	[ 1, 0, 10, 0, 8, 10, 8, 11, 10, -1 ],
	[ 10, 3, 11, 1, 3, 10, -1 ],
	[ 3, 2, 8, 2, 10, 8, 10, 9, 8, -1 ],
	[ 9, 2, 10, 0, 2, 9, -1 ],
	[ 8, 3, 0, 10, 1, 2, -1 ],
	[ 2, 10, 1, -1 ],
	[ 2, 1, 11, 1, 9, 11, 9, 8, 11, -1 ],
	[ 11, 2, 3, 9, 0, 1, -1 ],
	[ 11, 0, 8, 2, 0, 11, -1 ],
	[ 3, 11, 2, -1 ],
	[ 1, 8, 3, 9, 8, 1, -1 ],
	[ 1, 9, 0, -1 ],
	[ 8, 3, 0, -1 ],
	[ -1 ]
]

# for each edge what is the offset for middle point
var offset_table = [
	Vector3(-0.5, 0, 0),
	Vector3(-1, 0.5, 0),
	Vector3(-0.5, 1, 0),
	Vector3(-0, 0.5, 0),
	Vector3(-0.5, 0, 1),
	Vector3(-1, 0.5, 1),
	Vector3(-0.5, 1, 1),
	Vector3(-0, 0.5, 1),
	Vector3(-0, 0, 0.5),
	Vector3(-1, 0, 0.5),
	Vector3(-1, 1, 0.5),
	Vector3(-0, 1, 0.5)
]

# Insert setting up the PackedVector**Arrays here.
var surface_array = []
# PackedVector**Arrays for mesh construction.
var verts = PackedVector3Array()
var uvs = PackedVector2Array()
var normals = PackedVector3Array()
var indices = PackedInt32Array()

var indices_counter_id = 0

var counter = 0

var world = []
var world_verts_added = {}

func generate_world(x_l, y_l, z_l):
	var center_offset_parh = []
	center_offset_parh.append(Vector2(0, 0))
	for y in range(1, y_l):
		center_offset_parh.append(center_offset_parh[y-1])
		if randi_range(0, 10) > 5:
			center_offset_parh[y] += Vector2(randi_range(-4, 4), randi_range(-4, 4))
	
	var rng = RandomNumberGenerator.new() # used
	
	for x in range(x_l):
		world.append([])
		for y in range(y_l):
			world[x].append([])
			for z in range(z_l):
				var state_of_point
				if pow(x_l/2 + center_offset_parh[y].x - x, 2) + pow(z_l/2 + center_offset_parh[y].y - z, 2) < pow(x_l/2, 2)*0.02:
					state_of_point = false
				else:
					state_of_point = true
				
				if x == 0 or x == x_l-1 or y == 0 or y == y_l-1 or z == 0 or z == z_l-1: #????
					state_of_point = false
				
				#if x == 20: state_of_point = false
				world[x][y].append(state_of_point)


func add_triangle(combination, cur_position_x, cur_position_y, cur_position_z, x_unit, y_unit, z_unit):
	var i = 0
	while triangle_table[combination][i] != -1:
		var vert
		vert = offset_table[triangle_table[combination][i]]
		vert.x += cur_position_x
		vert.y += cur_position_y
		vert.z += cur_position_z
		
		vert.x *= x_unit
		vert.y *= y_unit
		vert.z *= z_unit
		
		if (world_verts_added.has(vert)):
			indices.append(world_verts_added[vert])
		else:
			verts.append(vert)
			indices.append(indices_counter_id)
			world_verts_added[vert] = indices_counter_id
			indices_counter_id += 1
		
		i += 1
		
		if i % 3 == 0 and false:
			var vec1 = verts[-1] - verts[-2]
			var vec2 = verts[-1] - verts[-3]
			var normal = vec1.cross(vec2)
			normal = normal.normalized()
			normals.append(normal)
		
		#uvs.append(Vector2(cur_position_x/len(world), cur_position_z/len(world)))
		


func generate_mesh(x_unit, y_unit, z_unit):
	verts.clear()
	indices.clear()
	indices_counter_id = 0
	mesh_instance.mesh = ArrayMesh.new()
	
	for x in range(len(world)-1):
		for y in range(len(world[x])-1):
			for z in range(len(world[x][y])-1):
				var points = [
					world[x][y][z],
					world[x+1][y][z],
					world[x][y+1][z],
					world[x+1][y+1][z],
					world[x][y][z+1],
					world[x+1][y][z+1],
					world[x][y+1][z+1],
					world[x+1][y+1][z+1]
				]
				
				var comb = 0
				for i in range(0, 8):
					if int(points[i]): comb += int(pow(2, i))
				
				#if x%2 == 0:
				#	print(1)
				add_triangle(comb, -x, y, z, x_unit, y_unit, z_unit) # pass units to add_triangle
				#else:
				#	print(2)
				#add_triangle(comb, -1, 0, 1) # pass units to add_triangle
	
	# Assign arrays to surface array.
	if(!verts.is_empty()):
		surface_array[Mesh.ARRAY_VERTEX] = verts
		#surface_array[Mesh.ARRAY_TEX_UV] = uvs
		#surface_array[Mesh.ARRAY_NORMAL] = normals
		surface_array[Mesh.ARRAY_INDEX] = indices
		# Create mesh surface from mesh array.
		# No blendshapes, lods, or compression used.
		mesh_instance.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
		mesh_instance.mesh.regen_normal_maps()
		
		var col_shape = mesh_instance.mesh.create_trimesh_shape()
		collision_shape.shape = col_shape


func _ready():
	surface_array.resize(Mesh.ARRAY_MAX)
	
	generate_world(65, 65, 65)
	generate_mesh(1, 1, 1)


func _process(delta):
	pass
