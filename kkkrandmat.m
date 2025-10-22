function [Z] = kkkrandmat(eiglst,cplxTrd,orth)
%% eigen value list
    eiglst      = eiglst(:);
    Nnode       = size(eiglst(:),1);
%% input parameter setting
    if ~exist('cplxTrd','var')
        cplxTrd=0;
    end
    if ~exist('orth','var')
        orth=0;
    end
    orth    = max(0  ,min(orth,1  ));
%% # of complex eig.
% cplxTrd : -1~1
%       >0: min. percentage of complex pair
%       <0: max. percentage of complex pair
    if cplxTrd>=0
        if cplxTrd>0.99
            cplxTrd=0.99;
        end
        Ncomp       = floor( ( cplxTrd+(1-cplxTrd)*rand ) * ( 1+floor(Nnode/2) ) );
    elseif cplxTrd<0
        if cplxTrd<-1
            cplxTrd=-1;
        end
        Ncomp       = floor( ( (1+cplxTrd)*rand ) * ( 1+floor(Nnode/2) ) );
    end
%% randomizing eig
    [~,ind]     = sort(rand(1,Nnode));
    Dcomp_r     = eiglst(ind<=Ncomp);
    Dcomp_i     = eiglst((ind>Ncomp)&(ind<=2*Ncomp));
    Dreal       = eiglst(ind>2*Ncomp);
%% generating B-diagonal matrix
    D0          = diag(Dreal);
    for i=1:Ncomp
        D0=blkdiag(D0,[Dcomp_r(i),-Dcomp_i(i);Dcomp_i(i),Dcomp_r(i)]);
    end
%% combining the rand matrix
    rev         = zeros(Nnode);
    Z           = zeros(Nnode);
        %    numerical inv.          all nodes are connected
    while ~isempty(lastwarn())||(max(conncomp(digraph((Z~=0)|(Z~=0)')))>1)
        lastwarn('', '');
        rev         = zeros(Nnode);

        P       = randn(Nnode);
        for i=1:Nnode
            P(:,i)=P(:,i)/norm(P(:,i));
            rndL=rand(1);
            P(:,i)=P(:,i)*rndL;
        end
        [U,~,V] = svd(P);
        O       = U*V';
        Q       = P-O;
        rev     = O+(1-orth)*Q;
   
        Z           = rev*D0/rev;
    end
%     Zs  = (Z+Z');
%     Zas = (Z-Z');
%     Z2  = sym*Zs+(1-sym)*Zas;
%     Z   = Z2;
end

