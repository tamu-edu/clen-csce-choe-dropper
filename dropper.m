# function I = dropper(n, num_rays, ray_int, obj_pos, obj_size, obj_vel, loc, t)
#
#	n: 		arena is n x n pixels
#	num_rays:	number of rays (odd number)
#	ray_int:	angel between rays (degrees)
#	obj_pos:	vector containing position of falling objects
#	obj_size:	vector containing object diameters
#	obj_vel:	vector containing object velocities (pixel/iter)
#	loc:		catcher location
#	t:		iteration #
#
#	Returns I:	vector of ray responses
#
function I = dropper(n, num_rays, ray_int, obj_pos, obj_size, obj_vel, loc, t)

A = zeros(n,n);

#--------------------
# set up rays: this should be done offline
#--------------------

R = rays(n,num_rays,ray_int);

#--------------------
# move around 
#--------------------

end
