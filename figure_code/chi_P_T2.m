function [] = chi_P_T2(ax,RR,IN)
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
    
    xx  = RR.AS;
    yy  = PP;
    cc  = RR.tseplst;
    zz  = cc;
    
    [~,sind]=sort(zz);
    xx=xx(sind);
    yy=yy(sind);
    zz=zz(sind);
    cc=cc(sind);
    
    XL=[1e-3 1e3];      xticks([1e-3 1e0 1e3])
    YL  = [0.1 1e3];    yticks([1e-1 1e0 1e1 1e2 1e3])
%     YL  = [0.3 1e1];    yticks([0.5 1 10])
    CL  = [10.^(floor(min(log10(cc)))) 10.^(ceil(max(log10(cc))))];
    CL(2)=max(CL(2),CL(1)*10);
    
    if IN.gray~=1
        scatter(xx,yy,psz,...
            cc,'filled','MarkerFaceAlpha',.3)
    else
        scatter(xx,yy,psz,...
            cc,'filled','MarkerFaceAlpha',.3,'MarkerFaceColor',[0 0 0])
    end
    fplot(@(x) (1/2)*(1+(1./(1+x)).^2),'--r','LineWidth',2)
    axis([XL YL]);
    caxis(CL)
    
    xlabel('\boldmath$\chi$','interpreter','latex','FontSize',13)
    ylabel('\boldmath$\frac{\sigma^2T}{\sigma^2_0T_0}/(\frac{\kappa}{\kappa_0})^2$','interpreter','latex','FontSize',13)
    
    if IN.gray~=1
        ccc=jet(128);
        colormap(ax,ccc);
        hcb=colorbar('location','west');
        hcb.Position(1) =     hcb.Position(1)+0.5 *hcb.Position(3);
        hcb.Position(2) =     hcb.Position(2)+0.52*hcb.Position(4);
        hcb.Position(4) = 0.3*hcb.Position(4);
        set(hcb,'TickLabelinterpreter','latex')
        set(hcb,'FontSize',10)
        title(hcb,'\boldmath$T/T_{2}$','VerticalAlignment','bottom','interpreter','latex')
    end
    
    set(ax,'XScale','log','YScale','log','ColorScale','log')
    set(ax,'box','on','LineWidth',2)

end

