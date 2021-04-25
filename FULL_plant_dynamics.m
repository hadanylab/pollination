function [ newD,newp2,seed_set_p1,seed_set_p2,con_pollen_p1,con_pollen_p2,hetero_pollen_p1,hetero_pollen_p2  ] = FULL_plant_dynamics( D,p2,Q1,Q2,Q3,V1,V2,V3,F1,F2)
%assume we have Q1,Q2,Q3 V1,V2,V3 F1,F2

global z_rate
global Smax
global h
%global half_saturation
global generation_length_in_seconds
global a1
global a2
%global c
%global alpha
global b1
global b2
global max_pollen_per_visit
global r1 
global r2
%global CM_penalty
%global dissimilarity
global Ke %efficiency of probing time on pollination
%global epsilon
global seed_exp_power
%global Fmax
%global g

Q1=vpa(Q1);
Q2=vpa(Q2);
Q3=vpa(Q3);
V1=vpa(V1);
V2=vpa(V2);
V3=vpa(V3);
F1=vpa(F1);
F2=vpa(F2);

[~,M1,M2] = get_gen_handling(p2,b1,b2);
%[~,M_r1,M_r2] = get_search_overhead(p2,r1,r2);



MIN_POL = 0;
Ke_collect = Ke;

Q1_pollen_collect_p1 = MIN_POL+(a1*F1+Ke_collect*b1)*z_rate;
Q2_pollen_collect_p2 = MIN_POL+(a2*F2+Ke_collect*b2)*z_rate;
Q3_pollen_collect_p2 = MIN_POL+(a2*F2+M2*Ke_collect*b2)*z_rate;
Q3_pollen_collect_p1 = MIN_POL+(a1*F1+M1*Ke_collect*b1)*z_rate;


Q1_pollen_deposit_p1 = MIN_POL+(a1*F1+Ke*b1)*z_rate;
Q2_pollen_deposit_p2 = MIN_POL+(a2*F2+Ke*b2)*z_rate;
Q3_pollen_deposit_p2 = MIN_POL+(a2*F2+M2*Ke*b2)*z_rate;
Q3_pollen_deposit_p1 = MIN_POL+(a1*F1+M1*Ke*b1)*z_rate;


p1=1-p2;

%consecutive visits to same type of flower deposit the same amount that
%they collected, so no need to limit the amount deposited
%this is per second per flower species
con_pollen_p1 = Q1_pollen_collect_p1*(Q1*V1) + Q3_pollen_collect_p1*(p1^2*Q3*V3);
con_pollen_p2 = Q2_pollen_collect_p2*(Q2*V2) + Q3_pollen_collect_p2*(p2^2*Q3*V3);
		
%non-consecutive visits can deposit different amount than they collected
hetero_pollen_p1 = min([Q3_pollen_deposit_p1,Q3_pollen_collect_p2,max_pollen_per_visit])*(p2*p1*Q3*V3);
hetero_pollen_p2 = min([Q3_pollen_deposit_p2,Q3_pollen_collect_p1,max_pollen_per_visit])*(p1*p2*Q3*V3);


%per plant, per second
con_pollen_p1 = con_pollen_p1/(D*p1);
con_pollen_p2 = con_pollen_p2/(D*p2);    
hetero_pollen_p1=hetero_pollen_p1/(D*p1);
hetero_pollen_p2=hetero_pollen_p2/(D*p2);

%per plant, overall
total_con_pollen_p1 = con_pollen_p1*generation_length_in_seconds;
total_con_pollen_p2= con_pollen_p2*generation_length_in_seconds;

total_hetero_pollen_p1 = hetero_pollen_p1*generation_length_in_seconds;
total_hetero_pollen_p2= hetero_pollen_p2*generation_length_in_seconds;

eff_con_pollen_p1=max(total_con_pollen_p1-h*total_hetero_pollen_p1,0);
eff_con_pollen_p2=max(total_con_pollen_p2-h*total_hetero_pollen_p2,0);


global g1
global g2

seed_set_p1=Smax*(1-exp(-seed_exp_power*eff_con_pollen_p1));
seed_set_p2=Smax*(1-exp(-seed_exp_power*eff_con_pollen_p2));


%this part is for different NPR mode only, defines the cost of quicker NPR
if abs(g1-g2)>eps
    if g1>g2
        %seed_set_p1=(g2/g1)*Smax*(1-exp(-seed_exp_power*eff_con_pollen_p1));
        seed_set_p1=(0.7)*Smax*(1-exp(-seed_exp_power*eff_con_pollen_p1));

    elseif g2>g1
    %if g2 refills twice as fast, it would have half the amount of seeds
        %seed_set_p2=(g1/g2)*Smax*(1-exp(-seed_exp_power*eff_con_pollen_p2));
        seed_set_p2=(0.7)*Smax*(1-exp(-seed_exp_power*eff_con_pollen_p2));
    end
end

if abs(seed_set_p2)>eps
    newp2 = p2*seed_set_p2/(p2*seed_set_p2+p1*seed_set_p1);
else
    newp2=0;
end


newD = D;
