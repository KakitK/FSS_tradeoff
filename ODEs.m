function [V] = ODEs(G,P,S,SET)
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
%% IN
    IN.S    = S;
    IN.xini = SET.xini(:);
    IN.xCtrl   = SET.xCtrl(:);
    clearvars -except G P V IN SET
%% INI
    V.ssflg = nan;
    V.S     = zeros(G.Nt,1);
    V.xdet  = nan*ones(G.Nt,G.Nnode);
    V.Jxx   = nan*zeros(G.Nnode,G.Nnode);
    V.dxdS  = zeros(G.Nnode,1);
    V.dxdSL = zeros(G.Nnode,1);
    clearvars -except G P V IN SET
%% deterministic properties
    S0      = IN.S;

    V.xdet      = zeros(size(V.xdet));
    V.xdet(1,:) = IN.xini(:)';

    ssCt    = 0;
    for indt = 2:G.Nt
        xdet            = V.xdet(indt-1,:)';
        
        xCtrl       = xdet;
        ind         = ~isnan(IN.xCtrl);
        xCtrl(ind)  = IN.xCtrl(ind);

        dxdet           = G.dt*regFun(xCtrl,xdet,S0,P);
        V.xdet(indt,:)  = xdet+dxdet;

%         if min(abs((dxdet./G.dt)))<G.keps
        if min(abs((norm(dxdet)./G.dt)))<G.keps
            ssCt    = ssCt+1;
            if ssCt>G.ssCth
                V.ssflg     = indt;
                for indtt = indt+1:G.Nt
                    V.xdet(indtt,:)     = V.xdet(indt,:);
                end
                break;
            end
        else
            ssCt    = 0;
        end
    end
    clearvars -except G P V IN SET
%% Jacobian
    x0=V.xdet(end,:)';
    S=IN.S;
    [reg0,~,~]=regFun(x0,x0,S,P);
    reg0=reg0(:);
%     dx=1e-5;
    dx=1e-10;
    J=nan*zeros(G.Nnode);
    for ind=1:G.Nnode
        x=x0;
        x(ind)=x0(ind)+dx;
        [reg,~,~]=regFun(x,x,S,P);
        J(:,ind)=reg(:)-reg0;
    end
    J=J/dx;
    V.Jxx=J;
    clearvars -except G P V IN SET
%% dR/dI deterministic
    ds      = P.ds;
    S0      = IN.S+ds;

    x00     = V.xdet(end,:)';
    x       = x00;

    ssCt    = 0;
    for indt = 2:G.Nt
        x0      = x;
        
        xCtrl       = x0;
        ind         = ~isnan(IN.xCtrl);
        xCtrl(ind)  = IN.xCtrl(ind);

        dx      = G.dt*regFun(xCtrl,x0,S0,P);
        x       = x0+dx;

%         if min(abs((dx./G.dt)))<G.keps
        if min(abs((norm(dx)./G.dt)))<G.keps
            ssCt    = ssCt+1;
            if ssCt>G.ssCth
                break;
            end
        else
            ssCt    = 0;
        end
    end
    V.dxdS  = (x-x00)/ds;
    clearvars -except G P V IN SET
%% dR/dI deterministic _left
    ds      = P.ds*-1;
    S0      = IN.S+ds;

    x00     = V.xdet(end,:)';
    x       = x00;

    ssCt    = 0;
    for indt = 2:G.Nt
        x0      = x;
        
        xCtrl      = x0;
        ind     = ~isnan(IN.xCtrl);
        xCtrl(ind) = IN.xCtrl(ind);

        dx      = G.dt*regFun(xCtrl,x0,S0,P);
        x       = x0+dx;

%         if min(abs((dx./G.dt)))<G.keps
        if min(abs((norm(dx)./G.dt)))<G.keps
            ssCt    = ssCt+1;
            if ssCt>G.ssCth
                break;
            end
        else
            ssCt    = 0;
        end
    end
    V.dxdSL = (x-x00)/ds;
    clearvars -except G P V IN SET
end

