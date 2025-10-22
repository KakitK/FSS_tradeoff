function [FIG] = ax1x1()
    
%% fig 1x2 w/o colorbar            w = 210
FIG.fg1     = figure('Position',[-0 450 300 300]);

FIG.axa     = axes('Position',[0.2  0.19 0.7 0.7]);hold on

FIG.axatop  = axes('Position',FIG.axa.Position);hold on;xticks([]);yticks([])
end

