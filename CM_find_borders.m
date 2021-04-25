function [ BD,AB,BC,CD,BD_border_CM,AB_border_CM,BC_border_CM,CD_border_CM ] = CM_find_borders(param1,param2,param3)


 
% numeric evaluation
% bd_p2(D) = simplify(solve(eval(BD_border),p2,'IgnoreAnalyticConstraints', true),'Steps',50)
% bc_p2(D) = simplify(solve(eval(BC_border),p2,'IgnoreAnalyticConstraints', true),'Steps',50)
% ab_p2(D) = simplify(solve(eval(AB_border),p2,'IgnoreAnalyticConstraints', true),'Steps',50)
% cd_p2(D) = simplify(solve(eval(CD_border),p2,'IgnoreAnalyticConstraints', true),'Steps',50)
% %

syms p2 F1 F2 b1 b2 a1 a2 p1 D

global g
global Fmax
global Sp
%global CM_penalty
global QTotal
global r1 r2



 if exist('param1','var')
      a1=param1;
      a2=param1;
      b1=param2;
      b2=param3;
 end

[beta_new,~,~] = get_gen_handling(p2,b1,b2);
[search_gen,~,~] = get_search_overhead(p2,r1,r2);

V1 = ((1/(Sp*sqrt(D)*p1))+a1*F1+b1+r1).^(-1);
V2 = ((1/(Sp*sqrt(D)*p2))+a2*F2+b2+r2).^(-1);
V3 = ((1/(Sp*sqrt(D)))+(a1*F1*p1+a2*F2*p2)+beta_new+search_gen).^(-1);


%[p1_correct_visit,p2_correct_visit] = get_visit_accuracy(r1,r2,b1,b2);
%p1_error_visit=1-p1_correct_visit;
%p2_error_visit=1-p2_correct_visit;



%
%
%AB border, F1=F2
%
%

eq4 = QTotal*V1/D == g*(1/F2-1/Fmax);
eq4 = subs(eq4,[F1,p1],[F2,1-p2]);
F2_solved = solve(eq4,F2,'ReturnConditions',true,'IgnoreAnalyticConstraints',true); %doesn't solve under the real-positive assumptions on F1-F2
F2_solved = simplify(F2_solved.F2,'Steps',50,'IgnoreAnalyticConstraints',true);

eq5 = 1/V1==1/V3;
eq5 = subs(eq5,[F1,p1],[F2,1-p2]);
F2_other = solve(eq5,F2,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);
if (isempty(F2_other.F2))
    %means that F2 is removed from the equation, this is already the border
    D_solved = solve(eq5,D,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);
    eq9 = D==D_solved.D;
else
    F2_other = simplify(F2_other.F2,'Steps',50,'IgnoreAnalyticConstraints',true);
    eq9 = F2_other == F2_solved;
end
AB_border_CM = eq9;
AB = solve(eq9,p2,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);


%
%
%BD border
%
%

eq2 = (p1/V1 + p2/V2) == 1/V3;
eq2 = subs(eq2,p1,1-p2);
eq2 = simplify(eq2,'IgnoreAnalyticConstraints',true,'Steps',50);

BD_border_CM = eq2;
BD = solve(eq2,p2,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);


%
%
%BC border, F2=Fmax, Q1=QTotal
%
%


eq1 = F1*V1 == ((1-p2)*F1+p2*Fmax)*V3;
eq1 = subs(eq1,F2,Fmax);
eq1 = subs(eq1,p1,1-p2);



F1_solved = solve(eq1,F1,'IgnoreAnalyticConstraints',true,'ReturnConditions',true);
F1_solved = simplify(F1_solved.F1,'Steps',50,'IgnoreAnalyticConstraints',true);
syms V1_tag positive

eq2 = F1_solved == Fmax/(1+(QTotal*Fmax*V1_tag)/(D*g*(1-p2)));

%CHANGED THIS TO TRY AND FIX FLOWER REPLENISHMENT TIME
%Vc_tag = QTotal*((b1+(1/(Sp*sqrt(D)*(1-p2))))^(-1))/(D*(1-p2));
%F1_solved = Fmax/(1+Vc_tag*Fmax/g);
%END OF CHANGE

%eq2 = F1_solved == Fmax/(1+Vc_tag*Fmax/g);
V1_solved = solve(eq2,V1_tag,'IgnoreAnalyticConstraints',true,'ReturnConditions',true);
V1_solved = simplify(V1_solved.V1_tag,'Steps',50,'IgnoreAnalyticConstraints',true);

eq3=  V1_solved * F1_solved == ((1-p2)*F1+p2*Fmax)*V3;

%eq3=  V1 * F1_solved == ((1-p2)*F1+p2*Fmax)*V3;
eq3 = subs(eq3,F2,Fmax);
eq3 = subs(eq3,p1,1-p2);
eq3 = subs(eq3,F1,F1_solved);

BC_border_CM = eq3;
BC = solve(eq3,p2,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);


%
%
%CD border, F2=Fmax
%
%

eq1 = F1*V1 == Fmax*V2;
eq1 = subs(eq1,F2,Fmax);
eq1 = subs(eq1,p1,1-p2);

F1_solved = solve(eq1,F1,'IgnoreAnalyticConstraints',true,'ReturnConditions',true);
F1_solved = simplify(F1_solved.F1,'Steps',50,'IgnoreAnalyticConstraints',true);
syms V1_tag positive

eq2 = F1_solved == Fmax/(1+(QTotal*Fmax*V1_tag)/(D*g*(1-p2)));

%CHANGED THIS TO TRY AND FIX FLOWER REPLENISHMENT TIME
%Vc_tag = QTotal*((b1+(1/(Sp*sqrt(D)*(1-p2))))^(-1))/(D*(1-p2));
%F1_solved = Fmax/(1+Vc_tag*Fmax/g);
%END OF CHANGE

V1_solved = solve(eq2,V1_tag,'IgnoreAnalyticConstraints',true,'ReturnConditions',true);
V1_solved = simplify(V1_solved.V1_tag,'Steps',50,'IgnoreAnalyticConstraints',true);
eq3=  V1_solved * F1_solved == Fmax*V2;

%eq3=  V1 * F1_solved == Fmax*V2;

eq3 = subs(eq3,F2,Fmax);

%added this after fix, wasn't here before
%eq3 = subs(eq3,p1,1-p2);
%eq3 = subs(eq3,F1,F1_solved);
%

CD_border_CM = eq3;
CD = solve(eq3,p2,'ReturnConditions',true,'IgnoreAnalyticConstraints',true);


