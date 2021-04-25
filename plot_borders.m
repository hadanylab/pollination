init_params;

plot1 = draw_CM_borders(1,2,5,'-',true);
plot2 = draw_CM_borders(1,2,10,'--',true);
plot3 = draw_CM_borders(1,2,15,':',true);

%r1=2 r2=4 
plot1 = draw_CM_borders(1,2,15,'-',true);
plot2 = draw_CM_borders(0.5,2,6,'--',true);

plot3 = draw_CM_borders(0.5,2,10,':',true);
plot4 = draw_CM_borders(0.5,2,15,'-.',true);

%r1=2 r2=4 
plot1 = draw_CM_borders(0.5,2,10,'-',true);
plot2 = draw_CM_borders(0.5,2,15,'--',true);


fplot(@(x) 52.6*(1-exp(-0.0163*x)),[0 400],'LineWidth',3)
set(gca,'FontSize',18);
xlabel('pollen grains','FontSize',18,'FontWeight','bold');
ylabel('seeds','FontSize',18,'FontWeight','bold');

