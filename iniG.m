function [G] = iniG(Nnode)
%% INC
%
%
%%
    G.tini      = 0;
    G.tend      = 2e4; %2e4
    G.dt        = 1e-2;
    G.t         = [G.tini:G.dt:G.tend]';
    G.Nt        = size(G.t(:),1);
    G.Nnode     = Nnode;

    G.ssT=100;
    G.ssCth     = ceil(G.ssT/G.dt);
%     G.ssCth=0;

    
    G.keps      = 1e-10;
end

