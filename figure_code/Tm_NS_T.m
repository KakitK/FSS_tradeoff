function [] = Tm_NS_T(ax,RR,IN)
%% pt size
    if size(RR.tScllst(:),1)>20000
        psz=1;
    else
        psz=3;
    end
    if ~exist('IN','var')
        IN.default=1;
    end
    if ~isfield(IN,'gray')
        IN.gray=0;
    end
%%
    axes(ax);cla reset;hold on
    
    indnode=1;
    FCsensi     = abs(0.5*(RR.dxdSlst(:,indnode)+RR.dxdSLlst(:,indnode))./RR.k0(:,indnode));
    FCnoise     = (RR.xslst(:,indnode).^2./(RR.dlt.^2.*RR.xmlst(:,indnode)));
    FCtScl      = (RR.tScllst)./(RR.tSclNFBlst);
    PP          = FCnoise.*FCtScl ./ (FCsensi.^2);
    
    xx  = RR.tSEPlst;
    yy  = FCnoise ./ (FCsensi);
    cc=FCtScl;
    zz  = cc;
    
    [~,sind]=sort(zz);
    xx=xx(sind);
    yy=yy(sind);
    zz=zz(sind);
    cc=cc(sind);
    
    XL  = [10.^(floor(min(log10(xx)))) 10.^(ceil(max(log10(xx))))];
    XL(2)=max(XL(2),XL(1)*10);xticks(XL)
    YL  = [0 2];
    CL  = [10.^(floor(min(log10(cc)))) 10.^(ceil(max(log10(cc))))];
    CL(2)=max(CL(2),CL(1)*10);

    if IN.gray~=1
        scatter(xx,yy,psz,...
            cc,'filled','MarkerFaceAlpha',.3)
        fplot(@(x) 2*sqrt(x)./(1+x),XL,'--','Color','k','LineWidth',1)
    else
        scatter(xx,yy,psz,...
            cc,'filled','MarkerFaceAlpha',.3,'MarkerFaceColor',[1 1 1]*0)
        fplot(@(x) 2*sqrt(x)./(1+x),XL,'--','Color','r','LineWidth',2)
    end
    
    axis([XL YL]);
    caxis(CL)
    
    xlabel('\boldmath$T/T_{min}$','interpreter','latex','FontSize',13)
    ylabel('\boldmath$\frac{\sigma^2}{\sigma^2_0}/|\frac{\kappa}{\kappa_0}|$','interpreter','latex','FontSize',13)
    
    if IN.gray~=1
        ccc=jet(128);
        colormap(ax,ccc);
        hcb=colorbar('location','south');
        hcb.Position(1) =     hcb.Position(1)+0.05*hcb.Position(3);
        hcb.Position(2) =     hcb.Position(2)+0.0 *hcb.Position(4);
        hcb.Position(3) = 0.4*hcb.Position(3);
        hcb.Position(4) = 0.7*hcb.Position(4);
        set(hcb,'TickLabelinterpreter','latex')
        set(hcb,'FontSize',10)
        xlabel(hcb,'\boldmath$T/T_0$','VerticalAlignment','bottom','interpreter','latex')
    end
    
    set(ax,'XScale','log','YScale','linear','ColorScale','log')
    set(ax,'box','on','LineWidth',2)
end

