
function fill_area(red_func,green_func,point_inter)
%fill function fills a polygon, so this is to create the vertices of the
%polygon

syms D
green_top = vpa(real(solve(green_func==0.49,D)));
red_top = vpa(real(solve(red_func==0.49,D)));

red_diff = abs(red_top-point_inter);
green_diff = abs(green_top-point_inter);


X_fill = [ point_inter point_inter+green_diff/10 point_inter+green_diff/3 point_inter+green_diff*2/3 green_top red_top red_top+red_diff/10 red_top+red_diff/3 red_top+red_diff*2/3 point_inter];

inter_val = double(red_func(point_inter));

Y_fill = [ inter_val double(green_func(point_inter+green_diff/10)) double(green_func(point_inter+green_diff/3)) double(green_func(point_inter+green_diff*2/3)) 0.49 0.49 double(red_func(red_top+red_diff/10)) double(red_func(red_top+red_diff/3)) double(red_func(red_top+red_diff*2/3)) inter_val];


fill(X_fill,Y_fill,[0.85 0.7 1],'EdgeColor','none','FaceAlpha',0.4);
