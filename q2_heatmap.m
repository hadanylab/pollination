init_params;
global b2
b2=15;


tic
D_arr=[logspace(0,2,100)];
p2_arr=[0.05:0.005:0.49];

qdata = zeros(length(p2_arr),length(D_arr));

for i=1:length(D_arr)
    currD = D_arr(i);
    for j=1:length(p2_arr)
        currp2 = p2_arr(j);
        [ Q1, Q2, Q3, V1, V2, V3, F1, F2 ] = abundances_region_d_CM( currD,currp2 );
        qdata(j,i) = Q2;
    end
end

toc
save(strcat('q2data_21102020_b.mat'));



%CLEAN UP THE MATRIX SO IT WOULD ONLY CONTAIN VALUES WITHIN AREA D
[black_plot,point_inter,right_black_func,right_blue_func,right_green_func,right_red_func,BD,AB,BC,CD] = draw_CM_borders(1,2,b2);

tic
qdata_clean = qdata; 
for i=1:length(D_arr)
    for j=1:length(p2_arr)
        [a_region,b_region,c_region,d_region] = getBorderPolygons(p2_arr(j),D_arr(i),right_green_func,right_red_func,right_blue_func,right_black_func,point_inter);
        if d_region~=1
            qdata_clean(j,i) = 0;
        end

    end
end
toc
save(strcat('q2data_clean_21102020_b.mat'));



h = heatmap(D_arr,fliplr(p2_arr),flipud(qdata_clean),'Colormap',flipud(hot),'GridVisible','off');
set(gca,'FontSize',16);
%h.Title = 'T-Shirt Orders';
h.XLabel = 'Total plant density';
h.YLabel = 'Rare plant frequency';


h.Title = {'Relative abundance of rare plant specialist (P_2)'};


%c = colorbar;
%c.Label.String = 'Abundance of rare plant specialist pollinators';