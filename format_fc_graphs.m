hFig = figure(1);
set(hFig, 'Position', [200 100 800 500])

p2_copy1=p2_crit_big_arr;


%p2_clean=[p2_crit_big_arr(:,1:50) p2_crit_big_arr(:,51:end)];
%D_clean=[D_arr(1:50) D_arr(51:end)];

p2_clean = p2_crit_big_arr;
D_clean = D_arr;

%%clean data
% for i=1:size(p2_clean,1) %short size
%     for j=1:size(p2_clean,2)-1 %long size
%         if p2_clean(i,j)<0.49
%             if (j==1 && p2_clean(i,j+1)==0.49)
%                 p2_clean(i,j)=0.49;
%             elseif j~=1 && p2_clean(i,j-1)==0.49 && p2_clean(i,j+1)==0.49
%                 p2_clean(i,j)=0.49;
%             end
%         end
%     end
% end
%p2_clean(p2_clean==0.49)=0.51;


plots=[];
%colors='bmgrykc';
colors='krkkkkk';
%styles={'-','--',':','-','-','-','-'};
%styles={'--',':','-.','-','-','-','-'};


styles={':','-','--',':','-','-','-','-'};


for i=1:size(p2_clean,1)
    %for i=4:7
    %smoothed = smooth(p2_clean(i,:),5);
    
    arr=p2_clean(i,:);
    %min_val = find(D_clean==200);
    %better_smoothed = [smooth(arr(1:min_val),3)' smooth(arr(min_val+1:end),15)'];
    
    better_smoothed = smooth(arr,3);
    plots(i) = semilogx(D_clean,better_smoothed,strcat(colors(int8(mod(i,8))),'-o'),'LineWidth',3,'Marker','None','MarkerSize',2,'LineStyle',strjoin(styles(int8(mod(i,8)))));
    
%     hold on
%     better_smoothed = smooth(arr,3);
%     plots(i) = semilogx(D_clean,better_smoothed,'b-o','LineWidth',1,'Marker','None','LineStyle',strjoin(styles(int8(mod(i,8)))));
%     
    hold on
end

% ax = gca;
% ax.YTick = [0 0.00005 0.0005 0.005 0.01 0.05 0.1 0.25 0.5];
% ax.XTick = [0 1 10 100 500 1000  2000 5000  10000];

xlabel('Total plant density','FontSize',20);
ylabel('Rare plant critical frequency','FontSize',20);

set(gca,'FontSize',20);

ylim([0 0.5]);


xlim([0 10^2]);


%title('Critical f_2 for polymorphism as a function of total plant density (s_1=20  P=0.1)','FontSize',14);
%title('Critical f_2 for polymorphism as a function of total plant density (r_1=1.2  P=0.1)','FontSize',14);

grid on


leg=[];
%legend('show');
if size(p2_copy1,1)==2
    leg = legend('b_2=4','b_2=10','Location','best');
elseif size(p2_copy1,1)==7
    leg = legend('b_2=1','b_2=1.2','b_2=1.5','b_2=2','b_2=5','b_2=5','b_2=10','Location','best');
elseif size(p2_copy1,1)==4
    leg = legend('b_2=1','b_2=1.5','b_2=2','b_2=5','Location','best');
    %leg = legend('d=0','d=0.8','d=0.9','d=1','Location','best');
    
elseif size(p2_copy1,1)==3
    leg = legend('g_1=2\cdotg_2','g_1=g_2','g_1=0.5\cdotg_2','Location','best');
    %leg = legend('b_1=5','b_1=10','b_1=15','Location','best');
    %leg = legend('b_2=1','b_2=2','b_2=5','Location','best');
elseif size(p2_copy1,1)==5
    leg = legend('d=0','d=0.7','d=0.8','d=0.9','Location','best');
end

if ~isempty(leg) 
    leg.FontSize=18;
end
%annotation('arrow',[0.27 0.27],[0.47 0.92],'Color','blue');
%annotation('arrow',[0.25 0.25],[0.8 0.9],'Color','blue');


