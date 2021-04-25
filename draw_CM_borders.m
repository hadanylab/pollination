function [black_plot,points2,right_black_func,right_blue_func,right_green_func,right_red_func,BD,AB,BC,CD] = draw_CM_borders(a1t,b1t,b2t,style,beautifyPlot)

disp('draw borders')
tic

%init_params


%DEBUG
%beautifyPlot=false;

if nargin==3
    style='-';
    beautifyPlot=false;
end

if nargin==4
    beautifyPlot=false;
end

% filename='C:\Users\Yael\Dropbox\Thesis_FromDropbox\Matlab\BorderFiles\CM_borders.mat';
% if isfile(filename)
%     load(filename);
% else
%     [ BD,AB,BC,CD,BD_border_CM,AB_border_CM,BC_border_CM,CD_border_CM] = CM_find_borders(a1t,b1t,b2t);
% end


global g1
global g2
if abs(g1-g2)<eps
    [ BD,AB,BC,CD,BD_border_CM,AB_border_CM,BC_border_CM,CD_border_CM] = CM_find_borders(a1t,b1t,b2t);
else
    [ BD,AB,BC,CD,BD_border_CM,AB_border_CM,BC_border_CM,CD_border_CM] = CM_find_borders_diff_g(a1t,b1t,b2t);
end

%global dissimilarity
global a1
global a2
global b1
global b2

a1=a1t;
b1=b1t;
b2=b2t+10^-10;
a2=a1t+10^-10;


warning('off','all');

syms D p2

%
% AB_ border_CM=subs(AB_border_CM,p2,p3);
% BC_border_CM=subs(BC_border_CM,p2,p3);
% BD_border_CM=subs(BD_border_CM,p2,p3);
% CD_border_CM=subs(CD_border_CM,p2,p3);

%assumeAlso(p3~=0); %Important assumption!

%style='-';


%p1=1-p2;

%beta_new = b1*p3*(1-p3)+b2*(1-p3)*p3;

%subsemilogx(2,2,4);
%title('Sp=0.01');

%% numeric evaluation
% syms y1
%
% test=subs(BD_border_CM);
% test=subs(test,p2,y1);
% bd_solve = solve(test,y1,'IgnoreAnalyticConstraints', true,'ReturnConditions',true);
% bd_p2(QDens) = subs(simplify(bd_solve.y1,'Steps',50));
%
% test=subs(BC_border_CM);
% test=subs(test,p2,y1);
% bc_solve = solve(test,y1,'IgnoreAnalyticConstraints', true,'ReturnConditions',true);
% bc_p2(QDens) = subs(simplify(bc_solve.y1,'Steps',50));
%
% test=subs(AB_border_CM);
% test=subs(test,p2,y1);
% ab_solve = solve(test,y1,'IgnoreAnalyticConstraints', true,'ReturnConditions',true);
% ab_p2(QDens) = subs(simplify(ab_solve.y1,'Steps',50));
%
% test=subs(CD_border_CM);
% test=subs(test,p2,y1);
% cd_solve = solve(test,y1,'IgnoreAnalyticConstraints', true,'ReturnConditions',true);
% cd_p2(QDens) = subs(simplify(cd_solve.y1,'Steps',50));

if class(BD)=="sym"
    bd_p2(D)=subs(BD);
    bc_p2(D)=subs(BC);
    ab_p2(D)=subs(AB);
    cd_p2(D)=subs(CD);
else
    bd_p2(D)=subs(BD.p2);
    bc_p2(D)=subs(BC.p2);
    ab_p2(D)=subs(AB.p2);
    cd_p2(D)=subs(CD.p2);
end




%red
bd_nonfunc = vpa(bd_p2(D));

%black
bc_nonfunc = vpa(bc_p2(D));

%green
cd_nonfunc = vpa(cd_p2(D));

%blue
ab_nonfunc = vpa(ab_p2(D));

%DEBUG! UNCOMMENT THIS
%it's slightly better if red function is first,
%since comparisons are of func1 to func3

[ points2,red_id,green_id,black_id ] = find_borders_intersect(bd_p2,cd_p2,bc_p2,false);
%points2 can in theory return null

%DEBUG
%green_id=0;
%points2=[];

if green_id==0
    red_id=1; %most common values
    green_id=2;
    black_id=1;
    disp('cant beautify plot')
    points2 = 10^3+1; %probably means the point is beyond the range of the graph
    %beautifyPlot=false;
end

right_green_func(D) = cd_nonfunc(green_id);
right_red_func(D)= bd_nonfunc(red_id);
right_black_func(D) = bc_nonfunc(black_id);



%THIS SHOULD BE ALWAYS NOT ZERO, BECAUSE NOW WE ARE EXTRACTING
%BLACK FUNC ID FROM FIND_BORDERS
% if black_id~=0
%     %decide which black is right
%     right_black_func(D) = bc_nonfunc(1); %placeholder
%     if ~isempty(points2)
%         vals = real(vpa(bc_p2(points2)));
%         val_red = real(vpa(right_red_func(points2)));
%         [M, black_id] = min(abs(vals-val_red));
%         right_black_func(D) = bc_nonfunc(black_id);
%     else
%         disp('couldnot find points2 intersect');
%     end
% else
%

%end of finding black func

%decide which blue is right
point_blue =500;
right_blue_func(D) = ab_nonfunc(2); %placeholder
hitzero = [];
hittop = [];
topsol=[];
zerosol=[];
i=0;
sol_red = vpasolve(right_red_func==0.5,D);

try
    while i<length(ab_nonfunc)
        i=i+1;
        %somehow can be more than one
        sol = real(vpa(solve(ab_nonfunc(i)==0.5,D)));
        sol2 = real(vpa(solve(ab_nonfunc(i)==0,D)));
        
        if ~isempty(sol2)
            hitzero = [hitzero ones(1,length(sol2))*i];
            zerosol=[zerosol sol2'];
        else
            hitzero=[hitzero -1];
            zerosol=[zerosol Inf];
        end
        if ~isempty(sol)
            hittop = [hittop ones(1,length(sol))*i];
            topsol = [topsol sol'];
        else
            hittop=[hittop -1];
            topsol=[topsol Inf];
        end
    end
    
    
    bottom_in_range = find(zerosol>0 & zerosol<10^4);
    only_top_in_range= find(topsol>0 & topsol<10^4 & topsol<sol_red);
    
    [bothinrange,ia,ib]=intersect(hitzero(bottom_in_range),hittop(only_top_in_range));
    
    
    if ~isempty(bothinrange)
        right_blue_func(D) = ab_nonfunc(bothinrange(1));
        point_blue = topsol(bothinrange(1));
    elseif ~isempty(only_top_in_range)
        right_blue_func(D) = ab_nonfunc(only_top_in_range(1));
        point_blue = topsol(only_top_in_range(1));
    else
        [temp, I] = min(topsol);
        right_blue_func(D) = ab_nonfunc(hittop(I));
    end
catch
    %DO nothing
    
end
%end of finding blue func

%this is just for plotting, so if not beautifyPlot can be small
if beautifyPlot==true

    idx=logspace(0,3,10^3);

    if isempty(points2)
        point_inter_start=0;
        point_inter_end=10^4;
    else
        if length(points2)>1
            
%             %PROBABLY CAN'T HAPPEN ANYMORE
%             
%             'ERROR, more than one intersect'
%             
%             [ points1,func1_id,func2_id ] = find_borders_intersect(right_blue_func,right_black_func);
%             inter=intersect(points1,points2);
%             
%             point_inter_start = inter(1)-10^1;
%             point_inter_end = point_inter_start+10^1;
        else
            point_inter_start = points2-10^1;
            point_inter_end=point_inter_start+10^1;
            
        end
    end
    
    
    %temp = find(idx>points2(1));
    %ind = temp(1)-1;
    
    
    bd_idx = logspace(0,log10(points2(1)),10^2); %red
    %bd_idx=idx(1:ind); %red
    cd_idx = logspace(log10(points2(1)),3,10^2); %green
    %cd_idx=idx(ind:end); %green
    %bc_idx = idx(1:ind); %black
    
    %optimizing time performance, because the black line is actually
    %very small
    tmp = 10^floor(log10(points2(1)));
    %THIS LINE BELOW WORKS BUT SOMETIMES THE OTHER DEFINITION IS BETTER
    %low_val = max([(points2/tmp)-1,0])*tmp;
    
    %for example if points2 is 720, I expect low_val to be 600
    low_val = (floor(points2/tmp)-1)*tmp; 
    bc_idx = linspace(low_val,points2,10^2); %black
    %   
    
    ab_idx=logspace(0,log10(point_blue),10^2); %blue
else
    idx=logspace(0,3,10^2);

    bc_idx=idx;
    
    cd_idx=idx;
    ab_idx=idx;
    bd_idx=idx;
end



%green_plot_values = smooth(double(right_green_func(cd_idx)),3);
%green_plot = plot(cd_idx,green_plot_values ,'LineWidth',5,'LineStyle',style);
%set(green_plot,'Color','green');

hold on
axis manual

set(gca,'XScale','log')
axis([1 10^3 0 0.49])




%GREEN NEEDS SPECIAL TREATMENT BECAUSE ALL THREE ROOTS ARE PART OF THE
%BORDER
green_plot_values = vpa(cd_p2(cd_idx));
tmp_idx = eval(green_plot_values>0 & green_plot_values<0.5);
green_plot_values = green_plot_values(tmp_idx);
cd_idx = cd_idx(logical(sum(tmp_idx)));
%scatter(cd_idx,green_plot_values,[],'green','filled');


%red_plot_values = smooth(double(right_red_func(bd_idx)),3);
%red_plot = plot(bd_idx,red_plot_values,'LineWidth',5,'LineStyle',style);
%red_plot = scatter(bd_idx,right_red_func(bd_idx),[],'red','filled');
red_plot_values = real(right_red_func(bd_idx));
%red_plot = scatter(bd_idx,red_plot_values,[],'red','filled');



%FILL AREA
%Fill before the plots so it doesn't cover the lines
%fill_area(right_red_func,right_green_func,points2(1));
if beautifyPlot==true
    fill([bd_idx cd_idx fliplr(cd_idx) fliplr(bd_idx)],...
        [double(red_plot_values) (double(green_plot_values))' ones(1,length(cd_idx))*0.5 ones(1,length(bd_idx))*0.5]...
        ,[17 17 17]/255,'EdgeColor','none','FaceAlpha',0.17);
end

green_plot = plot(cd_idx,green_plot_values,'LineWidth',5,'LineStyle',style);
set(green_plot,'Color','green');

red_plot = plot(bd_idx,red_plot_values,'LineWidth',5,'LineStyle',style);
set(red_plot,'Color','red');


%blue_plot = scatter(ab_idx,right_blue_func(ab_idx),[],'blue','filled');
blue_plot = plot(ab_idx,right_blue_func(ab_idx),'LineWidth',5,'LineStyle',style);
set(blue_plot,'Color','blue');


%black_plot = scatter(bc_idx,right_black_func(bc_idx),[],'black','filled','DisplayName',['b2=',b2]);
black_plot = plot(bc_idx,right_black_func(bc_idx),'LineWidth',5,'LineStyle',style,'DisplayName',['b2=',b2]);
set(black_plot,'Color','black');
%DEBUG
%delete(black_plot);


toc
