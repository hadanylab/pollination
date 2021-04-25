function [p1_correct_visit,p2_correct_visit] = get_visit_accuracy(r1,r2,b1,b2,p2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


%from Dyer & Chittka 2004
%x = [0.027 0.045 0.062 0.102 0.185 0.2 1]';
%y = [0.58 0.70 0.80 0.93 0.96 1 1]';
%f = fit(x,y,'rat23')
%plot(f,x,y)
%f(x) = (474*x^2 + 473.6*x + 5.504) /(x^3 + 1072*x^2 + 284.4*x + 24.02)
%x== color distance in hexagon units
%0.2 is maximum color distance in this study


%if the shape is different than there are no errors, that's from
%Dyer&Chittka 2004
if abs(b1-b2)>eps   
    p1_correct_visit=1;
    p2_correct_visit=1;
    return;
end



global min_r
r1_clean = r1-min_r;
r2_clean = r2-min_r;


color_distance = 0.2*abs(r1_clean-r2_clean)/max([r1_clean,r2_clean]); %max is 0.2

%this is a good fit
correct_visits_percent = @(x) (1-exp(-30*x))/(1+exp(-30*x));

p1 = 1-p2;

p1_correct_visit=correct_visits_percent(color_distance);
p2_correct_visit=correct_visits_percent(color_distance);

if color_distance==0
    p1_correct_visit = p1;
    p2_correct_visit = p2;
end





end

