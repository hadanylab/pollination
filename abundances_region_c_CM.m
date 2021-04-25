function [ Q1, Q2, Q3, V1, V2, V3, F1, F2 ] = abundances_region_c_CM( Dtag,p2tag )
% only the common type specialists exist


%-----------------------------------------------------------
syms F1 F2
global g

global g1
global g2

global Fmax
global Sp
%global c
global QTotal
global a1
global a2
global b1
global b2
global CM_penalty
global r1
global r2

p1tag=1-p2tag;
temp = (Sp*sqrt(Dtag))^(-1);
temp1 = ((Sp*sqrt(Dtag)*p1tag)^(-1));
temp2 = ((Sp*sqrt(Dtag)*p2tag)^(-1));
[beta_new,M1,M2] = get_gen_handling(p2tag,b1,b2,CM_penalty);
search_gen = get_search_overhead(p2tag,r1,r2);

%------------------------------------------------------------
[p1_correct_visit,p2_correct_visit] = get_visit_accuracy(r1,r2,b1,b2,p2tag);
p1_error_visit=1-p1_correct_visit;
p2_error_visit=1-p2_correct_visit;

V1 = (p1_correct_visit*(temp1+a1*F1+b1+r1)+p1_error_visit*(temp2+a2*F2+M2*b2+r2))^(-1);
V2 = (p2_error_visit*(temp1+a1*F1+M1*b1+r1)+p2_correct_visit*(temp2+a2*F2+b2+r2))^(-1);
V3 = (temp+a1*p1tag*F1+a2*p2tag*F2+beta_new+search_gen)^(-1);


Q1 = QTotal;
Q2 = 0;
Q3 = 0;

equation_q1 = Dtag*p1tag*g1*(1/F1-1/Fmax) == Q1*V1*p1_correct_visit;
equation_q2 = Dtag*p2tag*g2*(1/F2-1/Fmax) == Q1*V1*p1_error_visit;

[F_solve]=solve([equation_q1 equation_q2],[F1 F2]);

F1 = F_solve.F1;
F2 = F_solve.F2;



%F2 = Fmax;
%R2 = 0;
%V2 = (temp2+a2*F2+b2+r2)^(-1);
%R1 = g*(1/F1 - 1/Fmax);
%V1 = (temp1+a1*F1+b1+r1)^(-1);

%equation1 = V1 == R1*Dtag*p1tag/QTotal;
%solved_F1 = solve(equation1, F1,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);

%added this
%Vc_tag = QTotal*((b1+c+temp1)^(-1))/(Dtag*(1-p2tag));
%F1 = Fmax/(1+Vc_tag*Fmax/g);
%F1=subs(F1);
%



F1=vpa(F1);
F1 = F1(real(F1)>0 & real(F1)<=Fmax,1);
F1 = real(eval(F1));

F2=vpa(F2);
F2 = F2(find(real(F2)>0 & real(F2)<=Fmax,1));
F2 = real(eval(F2));

if ~isempty(F1) && ~isempty(F2)  
    V1 = subs(V1);
    V2 = subs(V2);
    V3 = subs(V3);     
else
    Q1=-1;
    Q2=0;
    Q3=0;
    F1=0;
    F2=0;
    V1=0;
    V2=0;
    V3=0;
end

if sign(vpa(Q1))<0
    msg = strcat('Abundances C failed');
    disp(msg);
end



end

