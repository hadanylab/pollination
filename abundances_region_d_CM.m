function [ Q1, Q2, Q3, V1, V2, V3, F1, F2 ] = abundances_region_d_CM( Dtag,p2tag )
%abundances of two species when they coexist (region Dtag)
%(only works for e=0)

%-----------------------------------------------------------
syms F1 F2
global g

global g1
global g2

global Fmax
global Sp
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
[search_gen,~,~] = get_search_overhead(p2tag,r1,r2);


%V1 = (temp1+a1*F1+b1+r1)^(-1);
%V2 = (temp2+a2*F2+b2+r2)^(-1);
V3 = (temp+a1*F1*p1tag+a2*F2*p2tag+beta_new+search_gen)^(-1);
%------------------------------------------------------------


%F2 = ((temp2+b2+r2)*F1/(temp1+b1+r1+(a1-a2)*F1));

% added this for error rate

syms Q1 Q2
[p1_correct_visit,p2_correct_visit] = get_visit_accuracy(r1,r2,b1,b2,p2tag);
p1_error_visit=1-p1_correct_visit;
p2_error_visit=1-p2_correct_visit;

V1 = (p1_correct_visit*(temp1+a1*F1+b1+r1)+p1_error_visit*(temp2+a2*F2+M2*b2+r2))^(-1);
V2 = (p2_error_visit*(temp1+a1*F1+M1*b1+r1)+p2_correct_visit*(temp2+a2*F2+b2+r2))^(-1);


%eq_fitness = V1*F1 == V2*F2;
eq_fitness = V1*(p1_correct_visit*F1+p1_error_visit*F2) == V2*(p2_correct_visit*F2+p2_error_visit*F1);

F2_solved(F1) = rhs(isolate(eq_fitness,F2));

%F2_solved is two solutions

equation_q1 = Dtag*p1tag*g1*(1/F1-1/Fmax) == Q1*V1*p1_correct_visit+(QTotal-Q1)*V2*p2_error_visit;
equation_q2 = Dtag*p2tag*g2*(1/F2-1/Fmax) == (QTotal-Q2)*V1*p1_error_visit+Q2*V2*p2_correct_visit;

%Q1_solved_orig = rhs(isolate(equation_q1,Q1));
%Q2_solved_orig = rhs(isolate(equation_q2,Q2));

[Q_solve] = solve([equation_q1 equation_q2],[Q1 Q2]);

equation_test = Q_solve.Q1+Q_solve.Q2 ==QTotal;
equation2 = subs(equation_test,F2,F2_solved); %can become more than one equation
equation2 = vpa(equation2);
F1_sol=[];
F2_sol=[];
for i=1:length(equation2)
    
    temp3 = solve(equation2(i),F1);
  
    temp3 = real(vpa(temp3));
    sol = temp3(temp3>0 & temp3<Fmax);
    
    
    %checking solutions
    checksol = subs(equation2,F1,sol);
    IND = abs(lhs(checksol)-rhs(checksol))<10^-3;
    sol = sol(IND);
    
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

assert(length(F1_sol)<=1);


F1=F1_sol;
F2=F2_sol;
if ~isempty(F1)
    Q1=subs(Q_solve.Q1);
    Q2=subs(Q_solve.Q2);
    
    V1 = subs(V1);
    V2 = subs(V2);
    V3 = subs(V3);     
    Q3 = 0;
else
    Q1=-1;
    Q2=-1;
    Q3=0;
    F1=0;
    F2=0;
    V1=0;
    V2=0;
    V3=0;
end


%assert(Q1+Q2==QTotal);


%end of adding for error rate



%equation2 = QTotal / (g*Dtag) == p1tag * (temp1+a1*F1+b1+r1) * (1/F1 - 1/Fmax) + ...
%   p2tag * (temp2+a2*F2+b2+r2)*(1/F2 - 1/Fmax);

%solved_F1 = solve(equation2, F1,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);
%F1 = solved_F1.F1;


%added this
% 
% syms Q1 Q2
% 
% Vc_tag = Q1*((b1+c+temp1)^(-1))/(Dtag*(1-p2tag));
% F1 = Fmax/(1+Vc_tag*Fmax/g);
% 
% Vr_tag = Q2*((b2+c+temp2)^(-1))/(Dtag*p2tag);
% F2 = Fmax/(1+Vr_tag*Fmax/g);
% 
% 
% eq1 = V1*F1 == V2*F2;
% eq1 = subs(eq1);
% eq1 = subs(eq1,Q1,QTotal-Q2);
% 
% 
% Q2_solved = solve(eq1,Q2,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);
% Q2 = vpa(Q2_solved.Q2); 
% 
% Q1 = QTotal-Q2;
% Q3 = 0;
% 
% F1 = subs(F1);
% F2 = subs(F2);
% V1 = subs(V1);
% V2 = subs(V2);
% V3 = subs(V3);
% %




%F1=vpa(F1);
%F1 = F1(real(F1)>0 & real(F1)<Fmax);
%F1 = real(eval(F1));

%F2 = subs(F2);
%F2 = vpa(F2);
%if (length(F2)>1)
%   ind = find(F2>0 & F2<Fmax);
%   F2=F2(ind);
%   F1=F1(ind);
%end
    
    
%R1 = g*(1/F1-1/Fmax);
%R2 = g*(1/F2-1/Fmax);

% V1 = subs(V1);
% V2 = subs(V2);
% V3 = subs(V3);
% 
% Q3 = 0;



%Q1 = vpa(R1* Dtag * p1tag / V1);
%Q2 = vpa(R2* Dtag * p2tag / V2);

if (Q1<0 || Q2<0 || Q1>QTotal || Q2>QTotal)
    msg = strcat('Abundances D failed');
    disp(msg);
end

end

