#----------------------------------------
# Ray activation demo
#----------------------------------------
R=rays(101,5,10); ts=time(); for i=1:1; t=0; for loc=49:-1:-50; B=balls(101,10,[-30,20],[0.5,2],t++); (activate(101,5,loc,move_ray(R,loc),B)); plotter(move_ray(R,loc)+B); end; end; time()-ts


R=rays(101,5,10); a=[]; ts=time(); for i=1:1; t=0; for loc=49:-1:-50; B=balls(101,10,[-30,20],[0.5,2],t++); m=move_ray(R,loc); a=activate(101,5,loc,m,B); figure(1); plotter(m+B); figure(2); bar(200-a); end; end; time()-ts

R=rays(101,5,10); ball_mask=ball(10); a=[]; ts=time(); for i=1:50; t=0; for loc=49:-1:-50; B=balls_using(101,10,[-30,20],[1,1],t++,ball_mask); m=move_ray(R,loc); a=activate(101,5,loc,m,B); end; end; time()-ts 

R=rays(101,5,10); ball_mask=ball(10); a=[]; ts=time(); for i=1:1; t=0; for loc=49:-1:-50; B=balls(101,10,[-30,20],[0.5,2],t++); m=move_ray(R,loc); a=activate(101,5,loc,m,B); figure(1); plotter(m+B); figure(2); bar(200-a); end; end; time()-ts

R=rays(101,5,10); ball_mask=ball(10); a=[]; ts=time(); for i=1:1; t=0; for loc=49:-1:-50; B=balls(101,10,[-30,20],[0.5,2],t++); m=move_ray(R,loc); a=activate(101,5,loc,m,B); figure(1); gset("yrange [0:100]"); gset("xrange [0:100]"); plotter(m+B); figure(2); gset("yrange [0:1]"); gset("xrange [0:6]"); bar((200-a)/200); end; end; time()-ts


#----------------------------------------
# GA (feed forward network): two balls
#----------------------------------------
p.num_drops=30; p.arena_size=101; p.num_rays=5; p.ray_interval=10; p.obj_size=10; p.n_hidden=5; p.n_individuals=20; p.retention_rate=0.2; p.mutation_rate=0.6; p.max_generation=5000; p.mutation_magnitude=0.5; p.error_thresh=0.00001; [gp,err,midx] = ga(p);

