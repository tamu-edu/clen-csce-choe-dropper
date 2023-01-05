# function B = balls_using(n,diameter,position,velocity,t,ball_mask)
#
#	n: 	  arena size is n x n
#	diameter: ball diameter (odd number)
#	position: vector containing x positions (-n/2:n/2)
#	velocity: vector containing fall velocity (pixel/sec)
#	t:        current time
#	ball_mask: object shape (diam x diam matrix)
#		   - use a precalculated obj to save time
#	
#	* Note: top of matrix is y min and bottom of matrix is y max.

function B = balls_using(n,diam,pos,vel,t,ball_mask)

#--------------------
# Put balls in position
#--------------------
B = zeros(n,n);

for k=1:length(pos)

	x = pos(k)+round((n-1)/2);

	# start from top y (bottom of the matrix)
 	y = n-(vel(k)*t); 
	y = round(max(y,diam));

	# put ball there
	B(y-diam+1:y,x-round(diam/2):x-round(diam/2)+diam-1)=ball_mask;
end

end
