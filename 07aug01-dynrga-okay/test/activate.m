# function Resp = activate(n, num_resp, pos, rays, balls)
# 
#	n	: arena size n x n
#	num_resp: ray response vector size
#	pos	: catcher's position (for calculating obj distance)
#	rays	: an n x n matrix with rays (must be pre-positioned)
#	balls	: an n x n matrix with balls
#
#	* Note: assumes rays have values 2, 4, 6, ...

function Resp = activate(n, num_resp, pos, rays, balls)

Resp = zeros(num_resp,1)+n*sqrt(2);

#--------------------
# Find intersecting rays 
#--------------------

detected = (rays.*balls)/2; # divide by 2 to make rays numbered 1, 2, 3, ...

#----------
# find non-zero entries
#----------
[y,x] = find(detected);

#----------
# check distance of all non-zero entries
#----------
for i=1:length(y)
  r = y(i);
  c = x(i);

  dist = sqrt((r-1)^2 + (c-(pos+n/2))^2);

  #----------
  # the value of the non-zero entry indicates the ray number: detected(r,c)
  #----------
  Resp(detected(r,c)) = min(Resp(detected(r,c)),dist);

end

Resp = ((n*sqrt(2))-Resp)/(n*sqrt(2));

end
	
