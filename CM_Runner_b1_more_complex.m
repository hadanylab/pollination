init_params;
%global a1
%global a2
%global b1
global recursion_counter


time_started = now;

p2_prev = -1;
D_prev = -1;

digits(10);
%before changing this, don't forget to look at the pollinator region borders
%see that they make sense

%b1=1;

%CORRECT VALUES FOR RUN
%accurate_delta = 0.01; %should be 0.01
%b2_arr=[5 10 15];
%D_arr=[linspace(1,9,50) logspace(1,2,50)];

%VALUES FOR DEBUG
accurate_delta = 0.01; %should be 0.01
b1_arr = [5 10 15];
b2 = 2; 

D_arr=[linspace(1,9,50) logspace(1,2,50)];
%

p2_epsilon=10^-3;

formatOut = 'yyddmmHHMMSS';
now_date=datestr(now,formatOut);
%results_file = strcat('C:\Users\yaelgure\Documents\MATLAB\Results\cm_results',now_date,'.csv');
results_name = strcat('C:\Users\Yael\Dropbox\Thesis_FromDropbox\Matlab\Results\cm_results',now_date);
results_file = strcat(results_name,'.csv');

fid = fopen(results_file, 'wt');
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',...
    'Qtotal','a1','a2','b1','b2','D','p2_prev','p2_next','A','B','C','D','Q1','Q2','Q3','V1','V2','V3','F1','F2','R1','R2','seed set1','seed set2','con poll1','conn poll2','hetero poll 1','hetero poll2','V1*F1','V2*F2');  % header
fclose(fid);


%p2_next_arr=[];
p2_crit_big_arr = zeros(length(b1_arr),length(D_arr));
p2_next_big_arr = zeros(length(b1_arr),length(D_arr));
seed_set1_big_arr = zeros(length(b1_arr),length(D_arr));
seed_set2_big_arr = zeros(length(b1_arr),length(D_arr));
poll_fitness1_big_arr = zeros(length(b1_arr),length(D_arr));
poll_fitness2_big_arr = zeros(length(b1_arr),length(D_arr));
poll_fitness3_big_arr = zeros(length(b1_arr),length(D_arr));
p2_no_morph_big_arr = zeros(length(b1_arr),length(D_arr));



%p2_next_big_arr = [];

%PATCH
global CM_CD

a_index=0;
for b1=b1_arr
  
    [black_plot,point_inter,right_black_func,right_blue_func,right_green_func,...
        right_red_func,CM_BD,CM_AB,CM_BC,CM_CD] = draw_CM_borders(a1,b1,b2);
   
    
    a_index=a_index+1;
    print_matrix=zeros(length(D_arr),30);
    
    
    b1
    
    p2_crit_arr=zeros(1,length(D_arr));
    p2_next_arr=zeros(1,length(D_arr));
    seed_set1_arr=zeros(1,length(D_arr));
    seed_set2_arr=zeros(1,length(D_arr));
    poll_fitness1_arr=zeros(1,length(D_arr));
    poll_fitness2_arr=zeros(1,length(D_arr));
    poll_fitness3_arr=zeros(1,length(D_arr));
    p2_no_morph_arr=zeros(1,length(D_arr));
    
    d_index=0;
    for D_next=D_arr
        tic
        try
        
        % QTotal = D_next*pollinator_plant_ratio;
        d_index=d_index+1;
        D_next
        

        [p2_next,a_region,b_region,c_region,d_region,Q1, Q2, Q3, V1, V2,V3,F1,F2,seed_set1,seed_set2,con_pollen_p1,con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2 ]...
            = get_next_p2(D_next,0.49,right_green_func,right_black_func,right_red_func,right_blue_func,point_inter);

        
        if (0.49-p2_next)>eps %decreasing
            p2_prev=0.5;
        else %0.49 is increasing
            
            recursion_counter=0;
            %find apriori the relevant range of p2, this is just for performance enhancement
            [p2_range,p2_next,a_region,b_region,c_region,d_region,Q1, ...
                Q2, Q3, V1, V2,V3,F1,F2,seed_set1,seed_set2,con_pollen_p1,...
                con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2] = p2_range_search(D_next,right_green_func,...
                right_black_func,right_red_func,right_blue_func,point_inter,0.05,0.49,accurate_delta,true);
            %the values Q1,Q2... returned should be the values for p2_range(1)
            disp('recursion counter 1');
            disp(recursion_counter);
            recursion_counter=0;
            
            if length(p2_range)>1 %otherwise it's p2_range = -1
%                 [p2_accurate_range,p2_next,a_region,b_region,...
%                     c_region,d_region,Q1, Q2, Q3, V1, V2,V3,F1,...
%                     F2,seed_set1,seed_set2,con_pollen_p1,con_pollen_p2,...
%                     hetero_pollen_p1,hetero_pollen_p2] = ...
%                     p2_range_search(D_next,right_green_func,...
%                     right_black_func,right_red_func,right_blue_func,...
%                     point_inter,p2_range(1),p2_range(2),accurate_delta,true);
                
                %disp('recursion counter 2');
                %disp(recursion_counter);
                
                %p2_prev = p2_accurate_range(end); 
                p2_prev = p2_range(end); 
                
            else
                
                p2_prev = p2_range(1);
                if p2_range ==-1
                    p2_prev = 0.5;
                end
                
                
            end
            
        end
        
        p2_next_arr(d_index)=p2_prev;
        p2_crit_arr(d_index)=p2_prev;
        seed_set1_arr(d_index)=seed_set1;
        seed_set2_arr(d_index)=seed_set2;
        poll_fitness1_arr(d_index)=V1*F1;
        poll_fitness2_arr(d_index)=V2*F2;
        poll_fitness3_arr(d_index)=V3*p2_prev*F2+V3*(1-p2_prev)*F1;
        
        
        if (F2==-1)
            print_row=zeros(1,30);
        else
            
            R1 = g*(1/F1-1/Fmax);
            R2 = g*(1/F2-1/Fmax);
            print_row = vpa([QTotal,a1,a2,b1,b2,D_next,p2_prev,p2_next,a_region,b_region,c_region,d_region,Q1,Q2,Q3,V1,V2,V3,F1,F2,R1,R2,seed_set1,seed_set2,con_pollen_p1,con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2,V1*F1,V2*F2]);
        end
        print_matrix(d_index,:)=print_row;
        
        toc
        catch
           disp('ERROR in D');
           d_index = d_index-1;
           continue; 
            
            
        end
    end %end of D
    
    dlmwrite(results_file, print_matrix, '-append');
    
    p2_next_big_arr(a_index,:)=p2_next_arr;
    p2_crit_big_arr(a_index,:) = p2_crit_arr;
    seed_set1_big_arr(a_index,:)=seed_set1_arr;
    seed_set2_big_arr(a_index,:)=seed_set2_arr;
    poll_fitness1_big_arr(a_index,:)=poll_fitness1_arr;
    poll_fitness2_big_arr(a_index,:)=poll_fitness2_arr;
    poll_fitness3_big_arr(a_index,:)=poll_fitness3_arr;
    p2_no_morph_big_arr(a_index,:)=p2_no_morph_arr;
    
    
    
end %end of a2

%save workspace variables to a file
save(strcat(results_name,'.mat'));

%close(gcf);
%format_fc_graphs_separate;
format_fc_graphs;
xlim([0 10^4]);

time_finished = now;


disp(datestr(time_started));
disp(datestr(time_finished));

