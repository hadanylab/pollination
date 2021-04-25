hold on
hFig = figure(1);
set(hFig, 'Position', [200 0 1000 600])


p2_clean=p2_crit_big_arr;
D_clean=D_arr;



% D_for_clean=[9 8.8367];
% 
% %CLEAN FIG
% for i=1:length(D_for_clean)
%     [ind] = find(D_clean==D_for_clean(i));
%     D_clean(ind)=[];
%     p2_clean(:,ind) =[];
% end




plots=[];
%colors='bmgrykc';
colors='kkkkkkk';
%styles={'-','--',':','-','-','-','-'};

%RIGHT ONE:
%styles={'-','--',':','-.','-','-','-'};

styles={'-','--',':',':','-','-','-','-'};


fill_color={[0.5,0.5,0.5], [0.5,0.5,0.5],[0.5,0.5,0.5],[0.5,0.5,0.5],[0.5,0.5,0.5],[0.5,0.5,0.5] };


fill_color = [100 30 22]./255;

for i=1:size(p2_clean,1)
    
    arr=p2_clean(i,:);
    better_smoothed = smooth(arr,'lowess',1);

    %better_smoothed = smooth(arr,3);
    %if i==1
    %    better_smoothed = smooth(arr,1);
    %end
    plots(i) = semilogx(D_clean,better_smoothed,strcat(colors(int8(mod(i,8))),'-o'),'LineWidth',4,'Marker','none','LineStyle',strjoin(styles(int8(mod(i,8)))));
    
    fill([D_clean fliplr(D_clean)],[better_smoothed' ones(1,length(better_smoothed))*0.5],...
        'r','EdgeColor','none','FaceAlpha',0.15);
    
    hold on
end

% ax = gca;
% ax.YTick = [0 0.00005 0.0005 0.005 0.01 0.05 0.1 0.25 0.5];
% ax.XTick = [0 1 10 100 500 1000  2000 5000  10000];

xlabel('total plant density (plant/m^2)','FontSize',20,'FontWeight','bold');
ylabel('fraction of rare plant species','FontSize',20,'FontWeight','bold');

set(gca,'FontSize',20);
set(gca,'xscale','log')

ylim([0 0.49]);
xlim([10^0 10^2]);
yticks([0:0.05:0.49]);
%title('Critical f_2 for polymorphism as a function of total plant density (s_1=20  P=0.1)','FontSize',14);
%title('Critical f_2 for polymorphism as a function of total plant density (r_1=1.2  P=0.1)','FontSize',14);

grid on



%legend('show');
if size(p2_clean,1)==2  
    [~, leg, ~, ~] = legend(plots,'b_2=15','b_2=15','Location','best');
elseif size(p2_clean,1)==5
    [~,leg] = legend(plots,'b_2=6','b_2=8','b_2=10','b_2=15','b_2=20');
elseif size(p2_clean,1)==4
    [~, leg, ~, ~] = legend(plots,'b_2=4','b_2=5','b_2=10','b_2=15','Location','best');
    
    
    
    %THIS
elseif size(p2_clean,1)==3
     %[hleg1,leg] = legend(plots,'g_1=2\cdotg_2','g_1=g_2','g_1=0.5\cdotg_2','Location','best');
   
    [hleg1,leg] = legend(plots,'b_2=5','b_2=10','b_2=15','Location','best');
     %set(hleg1,'position',[x0 y0 width height])
     set(hleg1,'position',[0.15 0.18 0.15 0.25])
    
    
    
elseif size(p2_clean,1)==5
    [~,leg] = legend('d=0','d=0.7','d=0.8','d=0.9','Location','best');
end

hl = findobj(leg,'type','line');
set(hl,'LineWidth',3);
legtxt = findobj(leg,'type','text');
set(legtxt,'FontSize',18);

%PATCH
%set(hleg1,'visible','off')




%annotation('arrow',[0.27 0.27],[0.47 0.92],'Color','blue');
%annotation('arrow',[0.25 0.25],[0.8 0.9],'Color','blue');



