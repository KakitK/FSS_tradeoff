%
% 2D and 10D all-noise main trade-off
%
%
%
%%
close all
clear
clc
%% figure
FIG=ax1x2;
%% 1a
load('result0726v1.mat');       %  2node 100k all noise
IN=[];
S_NT_T(FIG.axa,RR);
axes(FIG.axa);
% xlim([1e-5 1e5])
%% 1b
load('result0726v2.mat');       % 10node 100k all nosie
IN=[];
S_NT_T(FIG.axb,RR);
axes(FIG.axb);
% xlim([1e-5 1e5])
%% top
axes(FIG.axatop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')
axes(FIG.axbtop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')

%% save
savefig(FIG.fg1,'figureS4.fig')

set(FIG.fg1, 'InvertHardCopy', 'off');
set(FIG.fg1, 'Color', 'w');

print(FIG.fg1,'-r600','-dpng','figureS4.png')