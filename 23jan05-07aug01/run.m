addpath("..");
p.no_recurrency=0; p.decay_rate=0.6; p.num_drops=30; p.arena_size=101; p.num_rays=5; p.ray_interval=10; p.obj_size=10; p.n_hidden=5; p.n_individuals=20; p.retention_rate=0.2; p.mutation_rate=0.4; p.max_generation=50; p.mutation_magnitude=0.3; p.error_thresh=0.00001; [gp,err,midx] =  dynrga(p);
