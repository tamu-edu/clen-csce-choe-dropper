# function save_ga(gene_pool,bestx,best_gp,err,params,"dirname")
# 	Save critical info from the current gene_pool and the parameters,
#	in a newly created subdirectory "dirname"

function save_ga(gene_pool,bestx,best_gp,err,params,dirname)

mkdir(dirname);

eval(sprintf("cd %s",dirname));

n_individuals = length(gene_pool);

i2h = [];
h2o = [];
for i=1:n_individuals
	i2h = [i2h; gene_pool(i).input_to_hidden];
	h2o = [h2o; gene_pool(i).hidden_to_output];
end

param_list = struct_elements(params);

save_str = "";
for i=1:rows(param_list)
	eval(sprintf("params_%s = params.%s",param_list(i,:),param_list(i,:)));
	save_str = sprintf("%s params_%s",save_str,param_list(i,:));
end

best_i2h=best_gp.input_to_hidden;
best_h2o=best_gp.hidden_to_output;

eval(sprintf("save -ascii saved.dat i2h h2o bestx err best_i2h best_h2o %s",save_str));

cd ..

end
  
