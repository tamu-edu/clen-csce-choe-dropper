# gset stub, calling gnuplot_raw
function gset_stub(bla)

if (strcmp(version,"2.9.9")==1) 
	__gnuplot_set__(bla);
else
	gset(bla);
end

end
