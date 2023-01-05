#
# function R = rays(n,num_rays,ray_int)
#
# Input
#	n: 	  n x n target arena size 
#		  (returns an n x 2n, which can be cropped)
#	num_rays: number of rays (must be an odd number)
#	ray_int:  ray interval (in degrees)
#
#	* There's no error check so the numbers should be reasonable values.
#
# Output
#	R: an n x 2n arena with the rays centered in the middle
#	   The rays are numbered 2, 4, 6, ... .
#	* Note: top of R is y=0, and bottom y=n-1.
#
# You only need to create R once, and reuse it over and over again.
# By cropping R appropriately, you can simulate the catcher's movement:
#
#	loc=5; current_ray = R(:,100/2-loc:100/2+100-1-loc)
#

function R = rays(n,num_rays,ray_int)

#--------------------
# set up rays
#--------------------

R = zeros(2*n,n);

start_angle = -((num_rays-1)/2)*ray_int;
for i=1:num_rays
  angle = start_angle + (i-1)*ray_int;
  radian = angle*pi/180.0;
  a = tan(radian);
  b = n;
  marker = 2*i;
  for y=1:(2*n)
    for x=1:n
        if (round(y) == round(a*x+b))
                R(y,x) = marker;
        end
    end
  end
end

R = R';


end
