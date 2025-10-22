%
% 2D lower bound - chi relation
% 2D lower bound - T/T2 relation
%
%
%%
close all
clear
clc
%% figure
FIG=ax1x2;
%% 1a
load('result0724v1.mat');       %  2node 100k
IN=[];
chi_P_T2(FIG.axa,RR);
%% 1b
IN=[];
T2_P_chi(FIG.axb,RR);


%% top
axes(FIG.axatop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')
axes(FIG.axbtop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')

%% save
savefig(FIG.fg1,'figure3.fig')
set(FIG.fg1, 'InvertHardCopy', 'off');
set(FIG.fg1, 'Color', 'w');
print(FIG.fg1,'-r600','-dpng','figure3.png')