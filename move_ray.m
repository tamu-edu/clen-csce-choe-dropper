# function M = move_ray(R,loc)
#
#	R: 	n x 2n reference ray (centered)
#	loc: 	location (value between -2/n:2/n) 
#
#	M: 	resulting n x n matrix with the positioned ray

function M = move_ray(R,loc)

  n = rows(R);
 
  M = R(:,round(n/2)-loc:round(n/2)+n-1-loc);

end
