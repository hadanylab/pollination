function [ Q1, Q2, Q3,V1,V2,V3,F1,F2 ] = abundances_region_b_CM( Dtag,p2tag )
%abundances of common-species specialists and generalists (region B)


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

%F2 = (((temp+beta_new+search_gen)/(temp1+b1+r1))-p1tag)/((p2tag/F1)-p2tag*(a2-a1)/(temp1+b1+r1));


syms Q1 Q3

V1 = ((1/(Sp*sqrt(Dtag)*p1tag))+a1*F1+b1+r1).^(-1);
V2 = ((1/(Sp*sqrt(Dtag)*p2tag))+a2*F2+b2+r2).^(-1);
V3 = ((1/(Sp*sqrt(Dtag)))+(a1*F1*p1tag+a2*F2*p2tag)+beta_new+search_gen).^(-1);


eq_fitness = V1*F1 == V3*(p1tag*F1+p2tag*F2);
F2_solved(F1) = rhs(isolate(eq_fitness,F2));
%F2_solved is two solutions

equation_q1 = Dtag*p1tag*g1*(1/F1-1/Fmax) == Q1*V1+Q3*V3*p1tag;
equation_q2 = Dtag*g2*(1/F2-1/Fmax) == Q3*V3;

[Q_solve] = solve([equation_q1 equation_q2],[Q1 Q3]);


%Q1_solved_orig = rhs(isolate(equation_q1,Q1));
%Q2_solved_orig = rhs(isolate(equation_q2,Q3));

equation_test = Q_solve.Q1+Q_solve.Q3 ==QTotal;
equation2 = subs(equation_test,F2,F2_solved); %can become more than one equation
equation2 = vpa(equation2);
F1_sol=[];
F2_sol=[];
for i=1:length(equation2)
    
    temp3 = solve(equation2(i),F1);
  
    temp3 = real(temp3);
    sol = temp3(temp3>0 & temp3<Fmax);
    
    
    %checking solutions
    try
    checksol = subs(equation2,F1,sol);
    IND = abs(lhs(checksol)-rhs(checksol))<10^-3;
    sol = sol(IND);
    catch 
        %added this because sometimes division by zero exception can happen
        sol=[];
    end
    
    
    for k=1:length(sol)
        temp3 = vpa(F2_solved(sol(k)));
        temp3 = real(temp3);
        temp_sol = temp3(temp3>0 & temp3<Fmax);
        if ~isempty(temp_sol)
           assert(length(temp_sol)==1);           
           if isempty(find(abs(F1_sol-sol(k))<10^-3, 1)) %this means that the same value doesn't exist yet
                F1_sol = [F1_sol sol(k)];
                F2_sol = [F2_sol temp_sol];
           end
        end
    end
end

ind=[];
for k=1:length(F1_sol)
    q1_test = subs(Q_solve.Q1,[F1 F2],[F1_sol(k) F2_sol(k)]);
    if q1_test>0 && q1_test<QTotal
        ind=[ind k];
    end
end

if ~isempty(ind)
    F1_sol = F1_sol(ind);
    F2_sol=F2_sol(ind);
else
    F1_sol=[];
    F2_sol=[];
end


F1=F1_sol;
F2=F2_sol;
if ~isempty(F1) && ~isempty(F2)
    Q1 = subs(Q_solve.Q1);
    Q3 = subs(Q_solve.Q3);
    
    V1 = subs(V1);
    V2 = subs(V2);
    V3 = subs(V3);     
    Q2 = 0;
else
    Q1=-1;
    Q2=0;
    Q3=-1;
    F1=0;
    F2=0;
    V1=0;
    V2=0;
    V3=0;
end

% equation1 = QTotal / (g*Dtag) == p1tag*(1/F1-1/F2) * (temp1+r1+a1*F1+b1) + (1/F2 - 1/Fmax)*...
%    (temp+search_gen+beta_new+p1tag*a1*F1+p2tag*a2*F2);
% 
% solved_F1 = solve(equation1, F1,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);
% 
% F1 = solved_F1.F1;
% F1=vpa(F1);
% F1 = F1(real(F1)>0 & real(F1)<Fmax);
% F1 = real(eval(F1));
% 
% F2 = eval(F2);
% if (length(F2)>1)
%    ind = find(F2>0 & F2<Fmax);
%    F2=F2(ind);
%    F1=F1(ind);
% end
% 
% 
% 
% R1 = g*(1/F1 - 1/Fmax);
% R2 = g*(1/F2 - 1/Fmax);


%added this
% V1 = (temp1+a1*F1+b1+c)^(-1);
% V2 = (temp2+a2*F2+b2+c)^(-1);
% V3 = (temp+a1*p1tag*F1+a2*p2tag*F2+beta_new+c)^(-1);
% 
% 
% syms Q1 Q3
% Vc_tag = (Q1*((b1+c+temp1)^(-1))+Q3*(1-p2tag)*(beta_new+temp)^(-1))/(Dtag*(1-p2tag));
% F1 = Fmax/(1+Vc_tag*Fmax/g);
% 
% Vr_tag = Q3*(beta_new+c+temp)^(-1)/Dtag;
% F2 = Fmax/(1+Vr_tag*Fmax/g);
% 
% 
% eq1 = V1*F1 == ((1-p2tag)*F1+p2tag*F2)*V3;
% eq1 = subs(eq1);
% eq1 = subs(eq1,Q1,QTotal-Q3);
% 
% 
% Q2_solved = solve(eq1,Q3,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);
% Q3 = vpa(Q2_solved.Q3); 
% 
% 
% Q1 = QTotal-Q3;
% Q2 = 0;
% 
% 
% F1 = subs(F1);
% F2 = subs(F2);
% V1 = subs(V1);
% V2 = subs(V2);
% V3 = subs(V3);
%





%finding Qi
% Q1 = (Dtag*p1tag/V1) * (R1-R2);
% Q2 = 0;
% Q3 = Dtag*R2/V3;


if (Q1<0 || Q3<0 || Q1>QTotal || Q3>QTotal)
    msg = strcat('Abundances B failed');
    disp(msg);
end


end

