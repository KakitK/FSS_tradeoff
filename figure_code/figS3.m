%
% 10D lower bound - chi relation
% 10D lower bound - T/T2 relation
%
%
%%
close all
clear
clc
%% figure
FIG=ax1x2;
%% 1a
load('result0724v2.mat');       % 10node 100k
IN=[];
chi_P_T2(FIG.axa,RR);
%% 1B
IN=[];
IN.CL=[1e-1 1e2];
T2_P_chi(FIG.axb,RR,IN);

% axes(FIG.axb);
% caxis([1e-1 1e2])
%% top
axes(FIG.axatop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')
axes(FIG.axbtop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')

%% save
savefig(FIG.fg1,'figureS3.fig')
set(FIG.fg1, 'InvertHardCopy', 'off');
set(FIG.fg1, 'Color', 'w');
print(FIG.fg1,'-r600','-dpng','figureS3.png')