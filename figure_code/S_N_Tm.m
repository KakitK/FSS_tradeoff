function [] = S_N_Tm(ax,RR)
%% pt size
    if size(RR.tScllst(:),1)>20000
        psz=1;
    else
        psz=3;
    end
%% 
    axes(ax);cla reset;hold on
    
    indnode=1;
    FCsensi     = abs(0.5*(RR.dxdSlst(:,indnode)+RR.dxdSLlst(:,indnode))./RR.k0(:,indnode));
    FCnoise     = (RR.xslst(:,indnode).^2./(RR.dlt.^2.*RR.xmlst(:,indnode)));
    FCtScl      = (RR.tScllst)./(RR.tSclNFBlst);
    
    xx  = FCsensi;
    yy  = FCnoise;
    zz  = -RR.dataID;
    % cc  = FCtScl;
    cc=RR.tSEPlst;
    zz=-cc;
    
    [~,sind]=sort(zz);
    xx=xx(sind);
    yy=yy(sind);
    zz=zz(sind);
    cc=cc(sind);
    
    XL  = [1e-4 1e3];   xticks([1e-3 1e0 1e3])
    YL  = [1e-3 1e4];   yticks([1e-3 1e0 1e3])
    CL  = [10.^(floor(min(log10(cc)))) 10.^(ceil(max(log10(cc))))];
    CL(2)=max(CL(2),CL(1)*10);
    
    scatter(xx,yy,psz,...
        cc,'filled','MarkerFaceAlpha',.3)
    
    NS=@(x) 2*sqrt(x)./(1+x);
    % fplot(@(x) NS(CL(2))*x,XL,'k--','LineWidth',1)
    % fplot(@(x) x,XL,'k--','LineWidth',1)
    
    
    axis([XL YL]);
    caxis(CL)
    
    xlabel('\boldmath$|{\kappa}/{\kappa_0}|$','interpreter','latex','FontSize',13)
    ylabel('\boldmath${\sigma^2}/{\sigma^2_0}$','interpreter','latex','FontSize',13)
    
    ccc=jet(128);
    colormap(ax,ccc);
    hcb=colorbar('location','east');
    hcb.Position(1) =     hcb.Position(1)-0.5 *hcb.Position(3);
    hcb.Position(2) =     hcb.Position(2)+0.02*hcb.Position(4);
    hcb.Position(4) = 0.3*hcb.Position(4);
    set(hcb,'TickLabelinterpreter','latex')
    set(hcb,'FontSize',10)
    title(hcb,'\boldmath$T/T_{min}$','interpreter','latex','VerticalAlignment','bottom')
    
    
    set(ax,'XScale','log','YScale','log','ColorScale','log')
    set(ax,'box','on','LineWidth',2)

end

