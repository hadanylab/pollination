function [K,M1,M2] = get_gen_handling(p2,b1,b2,CM_penalty)

%global CM_Baseline
%if the plants are perfectly similar, there's no generalist penalty
%if the plants are different, there is a generalist penalty
%the more different they are, the more the penalty

 if ~exist('CM_penalty','var')
    CM_penalty=1;
 end
 
p1=1-p2;

% if isempty(CM_Baseline)
%     syms CM_Baseline_Multiply
% else
%     if (CM_Baseline==1)
%         CM_Baseline_Multiply=1/CM_penalty;
%     else
%         CM_Baseline_Multiply=1;
%     end
% end
% 
% K = p1^2*b1+p2^2*b2+(CM_penalty*CM_Baseline_Multiply)*p1*p2*(b1+b2);

%K = p1^2*b1+p2^2*b2+  p1*p2*(b1+b2) + 2*CM_penalty*abs(b1-b2)*p1*p2;

%M = (b1+b2)/(b2-b1); %assuming b2>b1


% generalist should be worse at the plant as its frequency is lower in the diet
%M1=1+std([b1,b2])/p1;
%M1=1+std([b1,b2])/(b1+b2);
%the problem i'm trying to solve is that for 1,10 the penalty is too high,
%its 12 or something. i'd like it to be 6? b2+b2*penalty

%PREVIOUS VERSION
%C = 1.5;
%M1=1+C*abs(b2-b1)/(b2+b1);
%M2=M1; 
%K = p1^2*b1+p2^2*b2+p1*p2*(M1*b1+M2*b2);


alpha = 1;
M2 = 1+p1^alpha;
M1 = 1+p2^alpha;
%K = p1^2*b1+p2^2*b2+p1*p2*(M2*b2)+p2*p1*(M1*b1);


K = p1*M1*b1+p2*M2*b2;



%


%C=2;
%M1 = C;
%M2 = C;
%NEW IDEA
%K = p1^2*b1+p2^2*b2+p1*p2*C*(b1+b2);
%


% fplot(@(p1) p1^2*b1*M1+(1-p1)^2*b2*M2+p1*(1-p1)*(b1+b2)*((1+std([b1,b2]))/p1+(1+std([b1,b2]))/(1-p1)),[0 0.5]);



end