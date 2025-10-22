%
% 2D and 10D gradient main trade-off result
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
load('result0725v1.mat');       %  2node 100k gradient
IN=[];
IN.gdt=2;
S_NT_T(FIG.axa,RR,IN);
axes(FIG.axa);
xlim([1e-5 1e5])
%% 1b
load('result0725v2.mat');       % 10node 100k gradient
IN=[];
IN.gdt=2;
S_NT_T(FIG.axb,RR,IN);
axes(FIG.axb);
xlim([1e-5 1e5])
%% top
axes(FIG.axatop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')
axes(FIG.axbtop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')

%% save
savefig(FIG.fg1,'figureS2.fig')

set(FIG.fg1, 'InvertHardCopy', 'off');
set(FIG.fg1, 'Color', 'w');

print(FIG.fg1,'-r600','-dpng','figureS2.png')