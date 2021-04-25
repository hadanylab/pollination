function [p2_range,p2_next,a_region,b_region,c_region,d_region,Q1, Q2, Q3, V1, V2,V3,F1,F2,seed_set1,seed_set2,con_pollen_p1,con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2] = p2_range_search(D_next,right_green_func,right_black_func,right_red_func,right_blue_func,point_inter,start_val,end_val,delta,stop_after_pos)
%the values Q1,Q2... should be the values of p2_range(2)
%IMPORTANT ASSUMPTION: end_val IS INCREASING


global recursion_counter
recursion_counter=recursion_counter+1;

mid_val = mean([start_val,end_val]);

%CHECK MIDDLE POINT
[p2_next,a_region,b_region,c_region,d_region,Q1, Q2, Q3, V1,...
    V2,V3,F1,F2,seed_set1,seed_set2,con_pollen_p1,...
    con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2 ]  = get_next_p2(D_next,...
    mid_val,right_green_func,right_black_func,right_red_func,right_blue_func,point_inter);

if (mid_val-p2_next)>eps %mid_val decreasing,minimum is in second half
    new_range = [mid_val end_val];
    last_known_increasing = end_val;
    %IN THIS CASE THE VALUES ARE WRONG BECAUSE THEY ARE FOR MID_VAL
else
    %mid_val increasing, minimum in first half
    new_range = [start_val mid_val];
    last_known_increasing = mid_val;
end


%STOPPING CONDITION
if abs(new_range(2)-new_range(1))<delta
    p2_range = new_range;
    
    if abs(new_range(2)-end_val)<eps
        %  JUST TO FIX THE VALUES FOR RETURN BECUASE IN THIS CASE THEY 
        %ARE FOR MID_VAL AND NOT FOR END_VAL LIKE THEY SHOULD
        [p2_next,a_region,b_region,c_region,d_region,Q1, Q2, Q3, V1,...
            V2,V3,F1,F2,seed_set1,seed_set2,con_pollen_p1,...
            con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2 ]  = get_next_p2(D_next,...
            end_val,right_green_func,right_black_func,right_red_func,right_blue_func,point_inter);
        
    end
    
    return;
else
    
    [p2_range,p2_next,a_region,b_region,c_region,d_region,...
        Q1, Q2, Q3, V1, V2,V3,F1,F2,seed_set1,seed_set2,...
        con_pollen_p1,con_pollen_p2,hetero_pollen_p1,...
        hetero_pollen_p2] = p2_range_search(D_next,right_green_func,right_black_func,right_red_func,right_blue_func,point_inter,...
        new_range(1),new_range(2),delta,stop_after_pos);
    
    if p2_range ==-1
        p2_range = last_known_increasing;
        
        [p2_next,a_region,b_region,c_region,d_region,Q1, Q2, Q3, V1,...
            V2,V3,F1,F2,seed_set1,seed_set2,con_pollen_p1,...
            con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2 ]  = get_next_p2(D_next,...
            last_known_increasing,right_green_func,right_black_func,right_red_func,right_blue_func,point_inter);
        return;
    else
        return;
    end
    
end

end




