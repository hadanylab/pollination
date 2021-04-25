function [ Q1, Q2, Q3, V1, V2, V3, F1, F2 ] = abundances_region_a_CM( Dtag,p2tag )

%-----------------------------------------------------------
syms F1 F2
global g
global Fmax
global Sp
%global c
global QTotal
global a1
global a2
global b1
global b2
%global CM_penalty
global r1 
global r2

global g1
global g2

p1tag=1-p2tag;
temp = (Sp*sqrt(Dtag))^(-1);
temp1 = ((Sp*sqrt(Dtag)*p1tag)^(-1));
temp2 = ((Sp*sqrt(Dtag)*p2tag)^(-1));
[beta_new,~,~] = get_gen_handling(p2tag,b1,b2);
[search_gen,~,~] = get_search_overhead(p2tag,r1,r2);

%------------------------------------------------------------

Q1 = 0;
Q2 = 0;
Q3 = QTotal;

F2 = F1;
V3 = (temp+a1*p1tag*F1+a2*p2tag*F2+beta_new+search_gen)^(-1);


R1 = g1*(1/F1 - 1/Fmax);

%added this
%Vc_tag = QTotal*((beta_new+c+temp)^(-1))/Dtag;
%F1 = Fmax/(1+Vc_tag*Fmax/g);
%

equation1 = V3 == R1*Dtag/QTotal;
solved_F1 = solve(equation1, F1,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);
F1 = solved_F1.F1;

F1=vpa(F1);
F1 = F1(real(F1)>0 & real(F1)<Fmax);
F1 = real(eval(F1));

F2 = eval(F2);
if (length(F2)>1)
    ind = find(F2>0 & F2<Fmax);
    F2=F2(ind);
    F1=F1(ind);
end


V3=eval(V3);

V1 = (temp1+a1*F1+b1+r1)^(-1);
V2 = (temp2+a2*F2+b2+r2)^(-1);


if sign(vpa(Q3))<0
    msgID = 'MYFUN:BadCalculation';
    msg = ['Abundances A, D: ',Dtag,' p_next: ',p2tag];
    baseException = MException(msgID,msg);
    throw(baseException);
end



end

