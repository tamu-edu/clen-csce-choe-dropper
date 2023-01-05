# $Id: ga.m,v 1.6 2006/09/02 16:47:17 yschoe Exp $
#
# Author: Yoonsuck Choe choe(a)tamu.edu
#	http://faculty.cs.tamu.edu
#
# License: GNU Public License -- see http://www.gnu.org
#
# GA test code, for supervised learning of feedforward neural networks with
# one hidden layer. * Recurrent connections in the hidden layer.
#
# function [gene_pool,gen_err,min_net] = dynrga(params)
#
#	input is a matrix, where each row is one instance vector.
#	target is a matrix, where each row is one target vector.
#
#	params.n_hidden is the number of hidden units (integer, e.g., 10)
#	params.n_individuals is the population size (integer, e.g., 500)
#	params.retention_rate is the retention rate of top performers (0.0-1.0)
#	params.mutation_rate is the mutation rate (0.0-1.0)
#	params.max_generation is the max number of generations before halting
#	params.mutation_magnitude is the scaling factor for mutation (0.0-1.0)
#	params.error_thresh is the error threshold for halting (e.g., 0.001)
#
#	returns:
#		gene_pool: array of all individuals (network weights)
#		gen_err: min error in each generation
#		min_net: index of best individual (in gene_pool).
#
#			gene_pool(min_net).input_to_hidden
#			gene_pool(min_net).hidden_to_output
#
#			gives the weight matrices of the best individual.
#	
# Example1: learn XOR
#
# p.n_hidden=10; p.n_individuals=20; p.retention_rate=0.2; p.mutation_rate=0.6; p.max_generation=5000; p.mutation_magnitude=0.5; p.error_thresh=0.00001; [gp,err,midx] = ga([-1 -1; -1 1; 1 -1; 1 1], [-1; 1; 1; -1], p); ih=gp(midx).input_to_hidden; ho=gp(midx).hidden_to_output; inp=[-1 -1 -1; -1 1 -1; 1 -1 -1; 1 1 -1]; outp=[-1 1 1 -1]'; hact=tanh(inp*ih); [r,c]=size(hact); hact(:,c)=-ones(r,1); [outp, tanh(hact*ho)]
#
#
# Example2: learn sin(x) across different inputs 
# 
# inp=(0:0.1:1.0)'; outp=[sin(inp*(2*pi))]/2; gset xrange [*:*]; gset yrange [*:*]; plot(outp); p.n_hidden=12; p.n_individuals=60; p.retention_rate=30/p.n_individuals; p.mutation_rate=4/p.n_hidden; p.max_generation=1000; p.mutation_magnitude=1.5; p.error_thresh=0.0005; [gp,err,midx] = ga(inp,[outp], p); ih=gp(midx).input_to_hidden; ho=gp(midx).hidden_to_output; inpb=[inp,-ones(rows(inp),1)]; hact=tanh(inpb*ih); [r,c]=size(hact); hact(:,c)=-ones(r,1); gset yrange [-1:1]; t=tanh(hact*ho); plot(inp,outp(:,1),inp,t(:,1),"3*-");

function [gene_pool,gen_err,min_net] = dynrga(params)

n_individuals = params.n_individuals;

#----------------------------------------
# neural network configuration
#----------------------------------------
n_output= 2; 	
n_hidden= params.n_hidden+1; 		# "+1" for bias unit
n_input = params.num_rays+params.n_hidden+1;		# "+1" for bias unit

recurrent_flag = 0; # unused, for now

#----------------------------------------
# other constants
#----------------------------------------
#input_count = rows(rawinput);

#----------------------------------------
# setup bias
#----------------------------------------
#input = [rawinput, -ones(input_count,1)];

#----------------------------------------
# initialize population (the connection weights)
#----------------------------------------

for i=1:n_individuals
	# initialize weights to small random values.
	gene_pool(i).input_to_hidden = rand(n_input,n_hidden);
	gene_pool(i).input_to_hidden -= mean(vec(gene_pool(i).input_to_hidden));
	gene_pool(i).hidden_to_output = rand(n_hidden,n_output);
	gene_pool(i).hidden_to_output -= mean(vec(gene_pool(i).hidden_to_output));
end

#----------------------------------------
# Initialize environment
#----------------------------------------
ray_mat = rays(params.arena_size,params.num_rays,params.ray_interval);
ball_mat = ball(params.obj_size);

#----------------------------------------
# Main loop
#----------------------------------------

for g=1:params.max_generation

#--------------------
# 1. calculate fitness
#--------------------
break_flag=0;
loc_max = floor(params.arena_size/2);

fprintf(stdout,"\n\n*** Generation %d",g);
fflush(stdout);


for i=1:n_individuals
	
   err(i) = 0;

   caught=zeros(1,params.num_drops);

   fprintf(stdout,".");
   fflush(stdout);

   # run for many different object configurations
   prev=0;
   success=0;
   for k=1:params.num_drops

	# center agent in the middle
	t = 0;
	loc = 0;

	objs = [ -round(rand*loc_max/2), round(rand*loc_max/2) ];
	if (rand>0.5)
		vels = [2,1];
	else
		vels = [1,2];
	end
	#objs = [ round(rand*loc_max/2-loc_max/4) ];
	#vels = [2];

	add_err=length(objs);

	prev_hidden=zeros(1,params.n_hidden);

	hidden = zeros(1,n_hidden);


	while (1) 

		#--------------------
		# generate current position and input
		#--------------------
		m = move_ray(ray_mat,loc);
		balls = balls_using(params.arena_size,params.obj_size,
				objs,vels,t++,ball_mat);
		input =activate(params.arena_size,params.num_rays,loc,m,balls)';
		input = [input, prev_hidden,-1];
		
		#--------------------
		# simple network activation
		#--------------------
                hidden_immediate = tanh(input*gene_pool(i).input_to_hidden);
                hidden = hidden_immediate *params.decay_rate+hidden*(1.0-params.decay_rate);
		hidden(n_hidden)=-1; # bias unit
		prev_hidden=hidden(1:params.n_hidden);
		output = tanh(hidden*gene_pool(i).hidden_to_output);

		#--------------------
		# move decision
		#--------------------
		if (output(1)>output(2))
			loc = min(loc+1,loc_max);
		else
			loc = max(loc-1,-loc_max);
		end

		#--------------------
		# plot it if the previous run looked promising
		#--------------------
		if (k==params.num_drops && success==1)
			figure(1);
	 		plotter(m+balls);
		end

		#--------------------
		# if ball is caught, remove it from obj list
		#--------------------
		idx=find(abs(objs-loc)<2);
		if (length(idx)>0)
			if (params.arena_size-t*vels(idx)<params.obj_size*2)
				fprintf(stdout,"c"); fflush(stdout);
				obj_loc = objs(idx);
				old_objs = objs;
				objs=objs(find(objs!=obj_loc));	
				vels=vels(find(old_objs!=obj_loc));	
				--add_err;
				caught(k)+=1;
			end
			if (add_err==0) 
				success=1;
				prev = 1;
				fprintf(stdout,"C"); fflush(stdout);
				break;
			end
		end

		#--------------------
		# if time's up, end loop
		#--------------------
		if (t*min(vels)>params.arena_size-params.obj_size)
			fprintf(stdout,"f"); fflush(stdout);
			err(i)=err(i)+add_err;	
			prev = 0;
			break;
		end

		#--------------------
		# if ball reaches the bottom, remove it from the obj list
		#--------------------
		rm_idx=0;
		for idx=1:length(vels)
			if (params.arena_size-t*vels(idx)<params.obj_size)
				rm_idx = idx;
				break;
			end
		end

		if (rm_idx != 0) 
			obj_loc = objs(rm_idx);
			old_objs = objs;
			objs=objs(find(old_objs!=obj_loc));	
			vels=vels(find(old_objs!=obj_loc));	
		end

		if (length(objs)==0)
			fprintf(stdout,"f"); fflush(stdout);
			err(i)=err(i)+add_err;	
			prev = 0;
			break;
		end

	end

   end ; # for all drops per individual

   # mean sqrt of sum squared error 
   #err(i)=err(i)/params.num_drops;

   [n,x]=hist(caught,[0,1,2]); 

   err(i)=(n(1)+n(2))/sum(n);
   err2(i)=n(1)/sum(n);

   # find best individual
   [gen_err(g),min_net] = min(err);

   # halt if error is below threshold
   if gen_err(g)<params.error_thresh
  	break_flag=1;
   end

   fprintf(stdout,"\n[Err=%f, f=%d, 1=%d, 2=%d]\n",err(i),n(1),n(2),n(3));
   fflush(stdout);
	
   purge_tmp_files

end

if break_flag==1
   break;
end

# If total failure, use single-catch error as error measure
if (!find(err<0.9999999)) 
	err = err2;
end

#
# plot fitness of the whole population
#
figure(2);
eval(sprintf("gset_stub(\"xrange [*:*]\")",params.error_thresh));
eval(sprintf("gset_stub(\"yrange [%f:*]\")",params.error_thresh));
loglog(err,"1-",err,"3*");

fprintf(stdout,"\n[MinErr=%f]\n",min(err));
fflush(stdout);

#--------------------
# 2. select top performers
#--------------------
[score,network_id]=sort(err);
n_retain = floor(n_individuals * params.retention_rate);

for i=1:n_retain
	gene_pool(i).input_to_hidden = gene_pool(network_id(i)).input_to_hidden;
	gene_pool(i).hidden_to_output = gene_pool(network_id(i)).hidden_to_output;
end

#--------------------
# 3. cross over
#--------------------
for i=n_retain+1:n_individuals

	#----------
	# Select parents randomly
	#----------
	dad_id = 0;
	mom_id = network_id(ceil(rand*(n_retain)));
	while (mom_id != dad_id) 
		dad_id = network_id(ceil(rand*(n_retain)));
	end

	#----------
	# Hidden
	#----------
	cross_over = ceil(rand*n_input);

	offspring = [gene_pool(mom_id).input_to_hidden(1:cross_over,:);
	             gene_pool(dad_id).input_to_hidden(cross_over+1:n_input,:)];

	gene_pool(i).input_to_hidden = offspring;

	#----------
	# Output
	#----------
	cross_over = ceil(rand*n_hidden);

	offspring = [gene_pool(mom_id).hidden_to_output(1:cross_over,:);
	             gene_pool(dad_id).hidden_to_output(cross_over+1:n_hidden,:)];

	gene_pool(i).hidden_to_output = offspring;

end

#--------------------
# 4. mutate
#--------------------
for i=1:n_individuals

	#----------
 	# Set mutation scale to be different between retained ones and their
	# offsprings.
	#----------
	if (i<=n_retain)
		scale=0.05; # retained ones have lower mutation rate
	else
		scale=1.0;
	end

	#----------
	# Hidden
	#----------
	mask = rand(n_input,n_hidden)>(1-params.mutation_rate);
	rmask = mask.*(0.5-rand(n_input,n_hidden))*params.mutation_magnitude*scale;
	smask = sum(vec(mask));

	if (smask != 0) 
	  m = sum(vec(rmask))/sum(vec(mask));
	  gene_pool(i).input_to_hidden = gene_pool(i).input_to_hidden+(rmask);
	end

	#----------
	# Output
	#----------
	mask = rand(n_hidden,n_output)>(1-params.mutation_rate);
	rmask = mask.*(0.5-rand(n_hidden,n_output))*params.mutation_magnitude*scale;
	smask = sum(vec(mask));

	if (smask != 0) 
	  m = sum(vec(rmask))/sum(vec(mask));
	  gene_pool(i).hidden_to_output = gene_pool(i).hidden_to_output+(rmask);
	end

end

end # end of main loop

gset_stub("xrange [*:*]");
gset_stub("yrange [*:*]");

end # end of function

