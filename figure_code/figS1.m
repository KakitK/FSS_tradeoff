%
% 2D and 10D no lower bound for fluctuation-sensitivity
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
load('result0724v1.mat');       %  2node 100k
IN=[];
S_N_Tm(FIG.axa,RR);
%% 1b
load('result0724v2.mat');       % 10node 100k
IN=[];
S_N_Tm(FIG.axb,RR);


%% top
axes(FIG.axatop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')
axes(FIG.axbtop);xticks([]);yticks([]);
set(gca,'box','on','LineWidth',2,'Color','None')

%% save
savefig(FIG.fg1,'figureS1.fig')
set(FIG.fg1, 'InvertHardCopy', 'off');
set(FIG.fg1, 'Color', 'w');
print(FIG.fg1,'-r600','-dpng','figureS1.png')