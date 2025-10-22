function [] = S_NT_T(ax,RR,IN)
%% pt size
    if size(RR.tScllst(:),1)>20000
        psz=1;
    else
        psz=3;
    end
    if ~exist('IN','var')
        IN.default=1;
        IN.gdt=0;
    end
    if ~isfield(IN,'gdt')
        IN.gdt=0;
    end
%% 
    axes(ax);cla reset;hold on
    
    indnode=1;
    FCsensi     = abs(0.5*(RR.dxdSlst(:,indnode)+RR.dxdSLlst(:,indnode))./RR.k0(:,indnode));
    FCnoise     = (RR.xslst(:,indnode).^2./(RR.dlt.^2.*RR.xmlst(:,indnode)));
    FCtScl      = (RR.tScllst)./(RR.tSclNFBlst);
    
    xx  = FCsensi.^2;
    yy  = FCnoise.*FCtScl;
    zz  = -RR.dataID;
    cc  = FCtScl;
    
    XL  = [1e-8 1e5];   xticks([1e-5 1e0 1e5])
    YL  = [.8e-5 1e6];  yticks([1e-5 1e0 1e5])
    CL  = [10.^(floor(min(log10(cc)))) 10.^(ceil(max(log10(cc))))];
    
    scatter(xx,yy,psz,...
        cc,'filled','MarkerFaceAlpha',.3)
    
    if IN.gdt==1
        fplot(@(x)     x,XL,'--','LineWidth',2,'Color',.7*ones(1,3))
    elseif IN.gdt==2
        fplot(@(x) 0.5*x,XL,'k--','LineWidth',1)
        fplot(@(x)     x,XL,'--','LineWidth',1,'Color',.7*ones(1,3))
    else
        fplot(@(x) 0.5*x,XL,'k--','LineWidth',1)
    end
    
    axis([XL YL]);
    caxis(CL)
    
    xlabel('\boldmath$({\kappa}/{\kappa_0})^2$','interpreter','latex','FontSize',13)
    ylabel('\boldmath$\frac{\sigma^2}{\sigma^2_0}\frac{T}{T_0}$','interpreter','latex','FontSize',13)
    
    ccc=jet(128);
    colormap(ax,ccc);
    hcb=colorbar('location','east');
    hcb.Position(1) =     hcb.Position(1)-0.5 *hcb.Position(3);
    hcb.Position(2) =     hcb.Position(2)+0.02*hcb.Position(4);
    hcb.Position(4) = 0.3*hcb.Position(4);
    set(hcb,'TickLabelinterpreter','latex')
    set(hcb,'FontSize',10)
    title(hcb,'\boldmath$T/T_0$','interpreter','latex','VerticalAlignment','bottom')
    
    
    set(ax,'XScale','log','YScale','log','ColorScale','log')
    set(ax,'box','on','LineWidth',2)
    
end

