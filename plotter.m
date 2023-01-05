# function plotter(X)
#
#	plots content of matrix X as an x-y plot
#

function  plotter(X)

  [i,j] = find(X);

  #yc gset_stub(sprintf("xrange [0:%d]",columns(X)));
  #yc gset_stub(sprintf("yrange [0:%d]",columns(X)));
  plot(j,i,"bo",0,0,".",columns(X),columns(X),".");
  drawnow();

end
	
