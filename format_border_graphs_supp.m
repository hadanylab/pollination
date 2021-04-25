
% plot1 = draw_CM_borders(1,2,5,'-',true);
% plot2 = draw_CM_borders(1,2,10,'--',true);
% plot3 = draw_CM_borders(1,2,15,':',true);

%% Format graph

hold on


hFig = figure(1);
set(hFig, 'Position', [200 0 900 600])

xlabel('total plant density (plant/m^2)','FontSize',18,'FontWeight','bold');
ylabel('fraction of rare plant species','FontSize',18,'FontWeight','bold');

set(gca,'FontSize',18);
set( gca,'FontName'   , 'Helvetica' );

set(gcf, 'PaperPositionMode', 'auto');
set(gca,'XLim',[1 10^3]);

% 
% ylim([0 0.5]);
% xlim([0 10^3]);

%title('Critical f_2 for polymorphism as a function of total plant density (s_1=10)','FontSize',14);
%title('critical f_2 (a=0.5, b_1=1)','FontSize',18);
%title('pollinator fitness at equlibrium (a=0.5, b_1=1)','FontSize',20);
%title('plant fitness at equilibrium (s_1=s_2=0.5)','FontSize',20);
%title('Region borders','FontSize',14);

%a_letter = text(1.6,0.45,'A','Color','black','FontSize',40);
a_letter = text(2,0.45,'A','Color','black','FontSize',40);
b_letter = text(3,0.18,'B','Color','black','FontSize',40);
%c_letter = text(500,0.11,'C','Color','black','FontSize',40);
c_letter = text(100,0.18,'C','Color','black','FontSize',40);
%d_letter = text(70,0.45,'D','Color','black','FontSize',40);
d_letter = text(10,0.45,'D','Color','black','FontSize',40);


%delete(a_letter); delete(b_letter); delete(c_letter); delete(d_letter);

%a_text = text(1.1,0.4,'generalists','Color','blue','FontSize',18);
a_text = text(1.1,0.4,'generalists','Color','blue','FontSize',18);
b_text1 = text(1.6,0.13,'generalists &','Color','blue','FontSize',18);
%b_text2 = text(1.6,0.1,'common specialists','Color',[0 0.5 0],'FontSize',18);
b_text2 = text(1.6,0.09,['common' newline 'specialists'],'Color',[0 0.5 0],'FontSize',18);

%c_text = text(300,0.05,['common' newline 'specialists'],'Color',[0 0.5 0],'FontSize',18);
c_text = text(80,0.11,['common' newline 'specialists'],'Color',[0 0.5 0],'FontSize',18);
%d_text1 = text(50,0.40,'common &','Color',[0 0.5 0],'FontSize',18);
%d_text2 = text(50,0.37,['rare ' 'specialists'],'Color',[0.7 0 0],'FontSize',18);

d_text1 = text(6,0.41,'common &','Color',[0 0.5 0],'FontSize',18);
d_text2 = text(6,0.36,['rare ' 'specialists'],'Color',[0.7 0 0],'FontSize',18);
%delete(a_text); delete(b_text1); delete(b_text2); delete(c_text); delete(d_text1); delete(d_text2);


%SHOW LEGEND
[~, hobj, ~, ~] =legend([plot1 plot2 plot3],'b_2=5','b_2=10','b_2=15','Location','best');
hl = findobj(hobj,'type','line');
set(hl,'LineWidth',2)
ht = findobj(hobj,'type','text');
set(ht,'FontSize',16);

legend('off')

