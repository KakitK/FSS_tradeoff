function [] = T2_P_chi(ax,RR,IN)
%% pt size
    if size(RR.tScllst(:),1)>20000
        psz=1;
    else
        psz=3;
    end
    if ~exist('IN','var')
        IN.default=1;
    end
    if isfield(IN,'psz')
        psz=IN.psz;
    end
%%
    axes(ax);cla reset;hold on
    
    indnode=1;
    FCsensi     = abs(0.5*(RR.dxdSlst(:,indnode)+RR.dxdSLlst(:,indnode))./RR.k0(:,indnode));
    FCnoise     = (RR.xslst(:,indnode).^2./(RR.dlt.^2.*RR.xmlst(:,indnode)));
    FCtScl      = (RR.tScllst)./(RR.tSclNFBlst);
    PP          = FCnoise.*FCtScl ./ (FCsensi.^2);
    
    xx  = RR.tseplst;
    yy  = PP;
    cc  = RR.AS;
    zz  = -cc;
    
    [~,sind]=sort(zz);
    xx=xx(sind);
    yy=yy(sind);
    zz=zz(sind);
    cc=cc(sind);
    
    % XL  = [1e0 1e2];
    XL  = [10.^(floor(min(log10(xx)))) 10.^(ceil(max(log10(xx))))]; 
    XL(2)=max(XL(2),XL(1)*10);xticks(XL)
    YL  = [0 2];    yticks([0 0.5 1 1.5 2])
    % CL  = [0 .5];
    if ~isfield(IN,'CL')
        CL=[1e-2 1e1];
    else
        CL=IN.CL;
    end
    
    scatter(xx,yy,psz,...
        cc,'filled','MarkerFaceAlpha',.3)
    fplot(@(x) 0.5*(1+((x-1)./(x+1))),XL,'--','Color','k','LineWidth',2)
    
    axis([XL YL]);
    caxis(CL)
    
    xlabel('\boldmath$T/T_{2}$','interpreter','latex','FontSize',13)
    ylabel('\boldmath$\frac{\sigma^2T}{\sigma^2_0T_0}/(\frac{\kappa}{\kappa_0})^2$','interpreter','latex','FontSize',13)
    
    ccc=jet(128);
    colormap(ax,ccc);
    hcb=colorbar('location','east');
    hcb.Position(1) =     hcb.Position(1)-0.5 *hcb.Position(3);
    hcb.Position(2) =     hcb.Position(2)+0.02*hcb.Position(4);
    hcb.Position(4) = 0.3*hcb.Position(4);
    set(hcb,'TickLabelinterpreter','latex')
    set(hcb,'FontSize',10)
    title(hcb,'\boldmath$\chi$','VerticalAlignment','bottom','interpreter','latex')
    
    hcb.Ticks=CL;
    
    set(ax,'XScale','log','YScale','linear','ColorScale','log')
    set(ax,'box','on','LineWidth',2)
end

