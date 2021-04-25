function [K,M_r1,M_r2] = get_search_overhead(p2,r1,r2)

%global dissimilarity
%if the plants are perfectly similar, there's no generalist penalty
%if the plants are different, there is a generalist penalty
%the more different they are, the more the penalty

p1=1-p2;

%if isempty(dissimilarity)
%    syms dissimilarity
%end


%dissimilarity = 1 ==> completely different
%dissimilarity =0 ==> completely similar, no search penalty ==> M1=1

%M1 = 1+dissimilarity/p1;
%M1=1+std([r1,r2])/(r1+r2);

%M1=1+abs(r2-r1)/mean([r1,r2]);
%M2=M1;
%K=p1*(p1*r1+M1*p2*r1) +p2*(p2*r2+M2*p1*r2);

%K = p1^2*r1+p2^2*r2+(1+SI_penalty*dissimilarity)*p1*p2*(r1+r2);


%NEW IDEA

%C=2;
%M1=1+C*abs(r2-r1)/(r2+r1);
%M2=M1;

%K = p1^2*r1+p2^2*r2+p1*p2*(M1*r1+M2*r2);
%

alpha = 1;
M_r2 = 1+p1^alpha;
M_r1 = 1+p2^alpha;

global min_r
K = p1*M_r1*(r1-min_r)+p2*M_r2*(r2-min_r)+min_r;


end