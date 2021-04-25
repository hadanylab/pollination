function [p2_output,a_region,b_region,c_region,d_region, Q1, Q2, Q3, V1, V2,V3,F1,F2,seed_set1,seed_set2,con_pollen_p1,con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2 ] = get_next_p2(D_next,p2_next,right_green_func,right_black_func,right_red_func,right_blue_func,point_inter)
global QTotal

%find out in which region the given point (D_next,p2_next) is located
[a_region,b_region,c_region,d_region] = getBorderPolygons(p2_next,D_next,right_green_func,right_red_func,right_blue_func,right_black_func,point_inter);


%the reason that the region may be wrong is because the borders are
%calculated without the correct/wrong visits, while the abundances are
%calculated with them. So if the plants are similar enough
%(get_visit_accuracy.m) sometimes the region might be wrong
if a_region==1
    
    [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_a_CM( D_next,p2_next); 
    
    %we have more than one try as explained above, in case the borders
    %don't match reality. the attempts are pretty much ordered by
    %probability.
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
        disp('not A, second try B')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_b_CM( D_next,p2_next);    
    end
    
elseif b_region==1
    
    [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_b_CM( D_next,p2_next);
    %second try
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
        disp('not B, second try A')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_a_CM( D_next,p2_next); 
    end
    %third try
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
        disp('not B, third try D')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_d_CM( D_next,p2_next); 
    end
    %fourth try
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
         disp('not B, fourth try C')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_c_CM( D_next,p2_next); 
    end
    
elseif c_region==1
    
    [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_c_CM( D_next,p2_next);
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
         disp('not C, second try D')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_d_CM( D_next,p2_next); 
    end
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
         disp('not C, third try B')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_b_CM( D_next,p2_next); 
    end
    
elseif d_region==1
    
    [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_d_CM( D_next,p2_next);
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
         disp('not D, second try C')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_c_CM( D_next,p2_next); 
    end
    if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
         disp('not D, second try B')
        [ Q1, Q2, Q3, V1, V2,V3,F1,F2 ] = abundances_region_b_CM( D_next,p2_next); 
    end
    
else
    error('COULD NOT DETECT REGION');
end


if (Q1<0 || Q2<0 || Q3<0 || Q1>QTotal || Q2>QTotal || Q3>QTotal)
    disp('still wrong area after all attempts')
    p2_output = -1;
    seed_set1=0;
    seed_set2=0;
    con_pollen_p1=0;
    con_pollen_p2=0;
    hetero_pollen_p1=0;
    hetero_pollen_p2=0;
else
    [~,p2_next,seed_set1,seed_set2,con_pollen_p1,...
        con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2] = FULL_plant_dynamics(D_next,p2_next,Q1,Q2,Q3,V1,V2,V3,F1,F2);
    
    p2_output=p2_next;
end


