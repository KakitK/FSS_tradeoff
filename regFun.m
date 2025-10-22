function [reg,regp,regn] = regFun(xCtrl,x,S,P)
%% include
%
%
%
%
%%
    satF    = @(z) 1./(1+exp(-z));
%%
    xCtrl   = xCtrl(:);
    x       = x(:);
    Nnode   = size(xCtrl(:),1);
    reg     = zeros(Nnode,1);
    regp    = zeros(Nnode,1);
    regn    = zeros(Nnode,1);
%%    
%% MWC
    for indn = 1:Nnode
        rr  = P.R0(indn);
        
        if P.RS(indn)~=0
            rr  = rr + P.RS(indn) * log(max(eps,1+   S/P.KS(indn) ));
        end
        for indn2 = 1:Nnode
            if P.FBflg(indn,indn2)==1
                rr  = rr + P.R(indn,indn2)* log (max(eps, 1 +     xCtrl(indn2)/P.K(indn,indn2) ));
            else
                rr  = rr + P.R(indn,indn2)* log (max(eps, 1 +         x(indn2)/P.K(indn,indn2) ));
            end
        end
        regp(indn,1)    = P.alpha(indn) * satF(rr);
        regn(indn,1)    = P.beta(indn)  * x(indn);
        reg(indn,1)     = regp(indn,1)-regn(indn,1);
    end

end

