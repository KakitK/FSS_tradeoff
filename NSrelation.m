function [OUT,P] = NSrelation(SET)
%% INC
% include iniG.m
% include iniP.m
% include ODEs.m
% include SDEs.m
%
%
%% default
    if ~exist('SET','var')
        SET.default=0;
    end
    if ~isfield(SET,'Nnode')
        SET.Nnode=2;
    end
%% IN
    IN.Nnode    = SET.Nnode;
%% G
    G   = iniG(IN.Nnode);                       % ini of the GLobal parameters
%% OUT
    OUT.errflg      = zeros(1,1);               

    OUT.Sref        = zeros(1,1);               % reference input signal level
    OUT.xdlst       = zeros(1,IN.Nnode);        % deterministic resposne
    OUT.xmlst       = zeros(1,IN.Nnode);        % mean resposne
    OUT.xslst       = zeros(1,IN.Nnode);        % std
    OUT.Jxx         = zeros(1,IN.Nnode.^2);     % Jacobian
    OUT.dxdSlst     = zeros(1,IN.Nnode);        % sensitivity dx/dS
    OUT.dxdSLlst    = zeros(1,IN.Nnode);        % sensitivity d(d-Delta x)/dS
    OUT.ssind       = zeros(1,1);
    
    clearvars -except IN OUT G P
%% Sref,P
    Sref=rand(1);
    P   = iniP(IN.Nnode,Sref);
%% main
    Nnode       = IN.Nnode;

    xdlst       = zeros(1,Nnode);
    xmlst       = zeros(1,Nnode);
    xslst       = zeros(1,Nnode);
    Jxx         = zeros(1,Nnode.^2);
    dxdSlst     = zeros(1,Nnode);
    dxdSLlst    = zeros(1,Nnode);

    ssind       = nan*zeros(1,1);
    
    ODEs_SET.default=0;
    SDEs_SET.default=0;
    ssflg=nan;

    errflg      = zeros(1,1);

    ssflg=nan;
    xini=P.xss;
    for inds=1:1
        % sensitivity , x_det
        ODEs_SET.xCtrl      = nan(Nnode,1);
        ODEs_SET.xini       = xini;
        S                   = Sref;
        [Vd]                = ODEs(G,P,S,ODEs_SET);
        xdlst(1,:)       = Vd.xdet(end,:);
        Jxx(1,:)         = Vd.Jxx(:)';
        dxdSlst(1,:)     = Vd.dxdS(:)';
        dxdSLlst(1,:)    = Vd.dxdSL(:)';
    
        ssflg=Vd.ssflg;
        ssind(1)=ssflg;
        if isnan(ssflg)
            errflg(1)=1;
            break;
        end
    
        xini    = Vd.xdet(end,:);
    
        % noise
        SDEs_SET.xCtrl      = nan(Nnode,1);
        SDEs_SET.xini       = xini;
        [Vs]                = SDEs(G,P,S,SDEs_SET);
        xmlst(1,:)       = mean(Vs.x(ssflg:end,:),1);
        xslst(1,:)       = std(Vs.x(ssflg:end,:),[],1);
    end


    OUT.errflg      = errflg;
    OUT.ssind       = ssind;
    OUT.Sref        = Sref;
    OUT.xdlst       = xdlst;
    OUT.xmlst       = xmlst;
    OUT.xslst       = xslst;
    OUT.Jxx         = Jxx;
    OUT.dxdSlst     = dxdSlst;
    OUT.dxdSLlst    = dxdSLlst;
    clearvars -except IN OUT G P Vs
%% 


%% OUT

end

