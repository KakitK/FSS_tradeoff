function [V] = SDEs(G,P,S,SET)
%% INC
% include regFun.m
%
%% default 
    if ~exist('SET','var')
        SET.default=0;
    end
    if ~isfield(SET,'xini')
        SET.xini=zeros(G.Nnode,1);
    end
    if ~isfield(SET,'xCtrl')
        SET.xCtrl=nan(G.Nnode,1);
    end
    if ~isfield(SET,'shadowNet')
        SET.shadowNet=0;
    end
%% IN
    IN.S            = S;
    IN.xini         = SET.xini(:);
    IN.xCtrl           = SET.xCtrl(:);
    IN.shadowNet    = SET.shadowNet;
    clearvars -except G P V IN SET
%% INI
    V.S     = zeros(G.Nt,1);
    V.x     = nan*ones(G.Nt,G.Nnode);
    clearvars -except G P V IN SET
%% stochastic simulation SDE
    S0          = IN.S;
    V.S         = S0*ones(G.Nt,1);
    V.x         = 0*V.x;
    V.x(1,:)    = IN.xini(:)';
    for indt = 2:G.Nt
        S               = V.S   (indt-1);
        x               = V.x   (indt-1,:)';

        xCtrl       = x;
        ind         = ~isnan(IN.xCtrl);
        xCtrl(ind)  = IN.xCtrl(ind);
        
        % canonical intrinsic noise
        [rF, rFp, rFn ] = regFun(xCtrl ,x ,S,P);
        dx              = G.dt*rF  + sqrt(G.dt)*P.dlti.*sqrt(rFp +rFn ).*randn(size(rF ));

        xt              = x+dx;
        xt(xt<0)        = 0;
        V.x(indt,:)     = xt;


        V.S(indt)       = S;
    end

end

