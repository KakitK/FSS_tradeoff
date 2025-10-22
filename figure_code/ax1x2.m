function [FIG] = ax1x2()
    
%% fig 1x2 w/o colorbar            w = 210
FIG.fg1     = figure('Position',[-0 450 630 300]);

FIG.axa     = axes('Position',[0.13  0.19 1/3 0.7]);hold on
FIG.axb     = axes('Position',[0.60  0.19 1/3 0.7]);hold on

FIG.axatop  = axes('Position',FIG.axa.Position);hold on;xticks([]);yticks([])
FIG.axbtop  = axes('Position',FIG.axb.Position);hold on;xticks([]);yticks([])

annotation('textbox',[0.03 0.83 0.01 0.01],'String','(a)','Unit','Normalized','FitBoxToText','off','edgeColor','None','HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',18,'FontName','Calibri','FontWeight','normal');
annotation('textbox',[0.50 0.83 0.01 0.01],'String','(b)','Unit','Normalized','FitBoxToText','off','edgeColor','None','HorizontalAlignment','left','VerticalAlignment','bottom','FontSize',18,'FontName','Calibri','FontWeight','normal');


end

