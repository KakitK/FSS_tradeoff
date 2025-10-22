function [P] = iniP(Nnode,Sref)
%% INC
% include kkkrandmat.m
% include kkkCHImat.m
%
%% default 
    if ~exist('Sref','var')
        Sref=rand(1);
    end
%% noise para    

    P.dlti      = (1e-4)*ones(Nnode,1);         % intrinsic nosie amplitude
    P.dlti(2:end)=0;
%% feedback flag
    P.FBflg     = ones(Nnode,Nnode);
%%  ODEs para:
    P.ds = 1e-10;   % for estimating slope (sensitivity)
%% overall range of timescale
    P.GlgTm     = -1;   % fastest
    P.GlgTM     =  1;   % slowest
    P.GlgTR     =  P.GlgTM-P.GlgTm;
%% range of log-timescasle
    P.lgTm  = P.GlgTm;
%     P.lgTM  =  1;
    P.lgTMM =  P.GlgTm+P.GlgTR*rand(1);

    P.lgTM  = P.lgTm+(P.lgTMM-P.lgTm)*rand(1);

%% MWC para-1D
    P.Nresam    = 0;
    P.Sref      = Sref;

    P.Nresam=P.Nresam+1;
    
    P.alpha     = 10.^(P.GlgTm+P.GlgTR*rand(Nnode,1));
    P.beta      = P.alpha;
%     P.lgTM      = max(1,1+log(beta(1))/log(10));
    P.xss       = 0.01+(0.99)*rand(Nnode,1);
    xssij       = (ones(Nnode,1)*P.xss(:)');
    P.fss       = P.xss.*P.beta./P.alpha;

    P.K         = 10.^(-1+2*rand(Nnode));
    P.KS        = 10.^(-1+2*rand(Nnode,1));

    P.RS        = 10.^(-1+2*rand(Nnode,1));
    P.RS(2:end) = 0;

    P.tScllst   = 10.^(P.lgTm+(P.lgTM-P.lgTm)*rand(Nnode,1));
    P.tScllst(1)    = 10.^P.lgTM;
    P.tScllst(end)  = 10.^P.lgTMM;
    P.eiglst    = -1./P.tScllst;

%     P.J         = kkkrandmat(P.eiglst,0,0);
%     P.J         = kkkrandmat(P.eiglst,0,rand(1));
%     P.J         = kkkrandmat(P.eiglst,-1,1);      % grdient system

    P.cplxTrd   = 0;
    P.orth      = 0;

    P.J         = kkkrandmat(P.eiglst,P.cplxTrd,P.orth);

    P.Jas       = (P.J-P.J')/2;
    P.Js        = (P.J+P.J')/2;
    P.chi       = norm(P.Jas)./(norm(P.Jas)-max(eig(P.Js)));
    
    P.R         = zeros(Nnode,Nnode);
    for i=1:Nnode
        for j=1:Nnode
            RR=P.J(i,j);
            if i==j
                RR=RR+P.beta(i);
            end
            RR  = RR./P.alpha(i);
            RR  = RR./P.fss(i);
            RR  = RR./(1-P.fss(i));
            RR  = RR.*(P.xss(j)+P.K(i,j));
            P.R(i,j)=RR;
        end
    end
    
    P.R0        = sum(-P.R.*log(1+(xssij./P.K)),2)-P.RS.*log(1+Sref./P.KS)-log((1./P.fss) -1);



    P.JS    = P.alpha.*P.fss.*(1-P.fss).*P.RS./(P.Sref+P.KS);

end

