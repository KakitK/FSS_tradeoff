%
% 2D and 10D high-noise main trade-off
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
load('result0727v1.mat');       %  2node 100k largenoise
IN=[];
S_NT_T(FIG.axa,RR);
axes(FIG.axa);
ylim([1e-5 1e4])
yticks([1e-4 1e0 1e4])
%% 1b
load('result0727v2.mat');       % 10node 100k largenosie
IN=[];
S_NT_T(FIG.axb,RR);
axes(FIG.axb);
ylim([1e-5 1e4])
yticks([1e-4 1e0 1e4])
%% top
axes(FIG.axatop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')
axes(FIG.axbtop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')

%% save
savefig(FIG.fg1,'figureS5.fig')

set(FIG.fg1, 'InvertHardCopy', 'off');
set(FIG.fg1, 'Color', 'w');

print(FIG.fg1,'-r600','-dpng','figureS5.png')