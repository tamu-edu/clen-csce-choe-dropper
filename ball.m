# function B = ball(diameter)
#
#	diameter: ball diameter (odd number)
#

function B = ball(diam)

B = zeros(diam,diam);

#--------------------
# Generate ball masks: make inside hollow
#--------------------
for i=1:diam
    for j=1:diam
 	if (sqrt((i-diam/2)^2+(j-diam/2)^2)<(diam/2))
	   B(i,j)=1;
 	end
 	if (sqrt((i-diam/2)^2+(j-diam/2)^2)<((diam/2)-2))
	   B(i,j)=0;
 	end
    end
end
			
end
