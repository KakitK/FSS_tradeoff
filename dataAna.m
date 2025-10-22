
%%
clear 
close all
clc
%%
try
    load(sprintf('dataSam2.mat'));
catch
    load(sprintf('dataSam10000.mat'));
end
Nbatch      = SET.totBatch;
batchSz     = SET.batchSz;
Nnode       = SET.Nnode;
dlti        = structR(1).P.dlti(1);
%%
RR.dlt          = structR(1).P.dlti(1)*ones(Nbatch*batchSz,1);

RR.xreflst      = nan*zeros(Nbatch*batchSz,Nnode);
RR.xdlst        = nan*zeros(Nbatch*batchSz,Nnode);
RR.xmlst        = nan*zeros(Nbatch*batchSz,Nnode);
RR.xslst        = nan*zeros(Nbatch*batchSz,Nnode);
RR.dxdSlst      = nan*zeros(Nbatch*batchSz,Nnode);
RR.dxdSLlst     = nan*zeros(Nbatch*batchSz,Nnode);
RR.tmp          = nan*zeros(Nbatch*batchSz,1);
RR.k            = nan*zeros(Nbatch*batchSz,Nnode);
RR.k0           = nan*zeros(Nbatch*batchSz,Nnode);
RR.dataID       = nan*zeros(Nbatch*batchSz,1);
RR.errflg       = nan*zeros(Nbatch*batchSz,1);
RR.ssind        = nan*zeros(Nbatch*batchSz,1);

RR.tScllst      = nan*zeros(Nbatch*batchSz,1);
RR.tSclNFBlst   = nan*zeros(Nbatch*batchSz,1);
RR.tseplst      = nan*zeros(Nbatch*batchSz,1);
RR.AS           = nan*zeros(Nbatch*batchSz,1);

indr        = 0;
errCount    = 0;
fprintf('%5.0f',0);
for inbt = 1:Nbatch
    fprintf('\b\b\b\b\b%5.0f',inbt);
    if ~exist(sprintf('dataSam%.0f.mat',inbt),'file')
        continue;
    end
    load(sprintf('dataSam%.0f.mat',inbt));
    Nnode   = SET.Nnode;
    for indSam = 1:SET.batchSz
        indr    = indr+1;
        RR.dataID(indr,1)     = inbt*1000+indSam;
        RR.errflg(indr,1)     = structR(indSam).OUT.errflg;
        RR.ssind(indr,1)      = structR(indSam).OUT.ssind;

        RR.xreflst(indr,:)    = structR(indSam).P.xss(:);

        RR.xdlst(indr,:)      = structR(indSam).OUT.xdlst;
        RR.xmlst(indr,:)      = structR(indSam).OUT.xmlst;
        RR.dxdSlst(indr,:)    = structR(indSam).OUT.dxdSlst;
        RR.dxdSLlst(indr,:)   = structR(indSam).OUT.dxdSLlst;

        RR.xslst(indr,:)      = structR(indSam).OUT.xslst;

        RR.k(indr,:)          = -(structR(indSam).P.J\structR(indSam).P.JS)';
        RR.k0(indr,:)         = (structR(indSam).P.JS./structR(indSam).P.beta)';


        RR.tSclNFBlst(indr,:)        = 1./structR(indSam).P.beta(1);

        J=structR(indSam).P.J;
        tscl=sort(1./(-real(eig(   J    ))));
        imageig=imag(eig(J));
        imageig((imageig<=0))=[];
        tsclf=sort(1./imageig);
        tsclf=[tsclf(:)',tscl(:)'];
        tsclf=sort(tsclf);
        

        RR.tScllst(indr,:)     = tscl(end);
        RR.tSEPFlst(indr,:)    = tsclf(end)./tsclf(1);
        RR.tSEPlst(indr,:)     = tscl(end)./tscl(1);
        RR.tseplst(indr,:)     = tscl(end)./tscl(end-1);

        Js  = (J+J')/2;
        Jas = (J-J')/2;
        RR.AS(indr,:)        =    norm(Jas)./(norm(Jas)-max(eig(Js)));
    end
end
fprintf('\nload finished!\n');
fprintf('%.0f error!!\n',errCount);

fnlst=fieldnames(RR);
for indfn = 1:size(fnlst,1)
    fn                      = fnlst{indfn};
    RR.(fn)(indr+1:end,:)   = [];
end

ind=zeros(size(RR.dxdSlst(:,1)))==1;
ind_hS      = ind;
ind_Poi     = ind;
ind_xd      = ind;
ind_xref    = ind;
ind_xdref   = ind;
ind_d2xds2  = ind;
ind_ssind   = ind;
ind_errflr  = ind;

ind_violate = ind;

ind_tmp     = ind;

ind_hS      = ind_hS     |((abs(RR.dxdSlst(:,1)))>1e1);                                        % extremely high sensitivity
ind_xd      = ind_xd     |(max(abs((RR.xdlst  -RR.xmlst))   ,[],2)>1e-3);                           % xm neq xd
ind_xref    = ind_xref   |(max(abs((RR.xreflst-RR.xmlst))   ,[],2)>1e-3);                           % xm neq xref
ind_xdref   = ind_xdref  |(max(abs((RR.xreflst-RR.xdlst))   ,[],2)>1e-3);                           % xd neq xref
ind_d2xds2  = ind_d2xds2 |(abs(log(RR.dxdSlst(:,1)./RR.dxdSLlst(:,1)))>log(1.5));                     % d2x/ds2 is extremely large

ind_ssind   = ind_ssind|(RR.ssind>3e4);
ind_errflr  = ind_errflr|(RR.errflg~=0);

FCsensi     = abs(0.5*(RR.dxdSlst(:,1)+RR.dxdSLlst(:,1))./RR.k0(:,1));
FCnoise     = (RR.xslst(:,1).^2./(RR.dlt.^2.*RR.xmlst(:,1)));
FCtScl      = (RR.tScllst)./(RR.tSclNFBlst);
PP          = FCnoise.*FCtScl ./ (FCsensi.^2);
ind_violate = ind_violate | PP<.9;

ind=ind|ind_xd;
ind=ind|ind_xref;
ind=ind|ind_xdref;
ind=ind|ind_d2xds2;
ind=ind|ind_ssind;
ind=ind|ind_errflr;

ind_violate=ind_violate&(~ind);


totResult=size(ind(:),1);
fprintf('N violating      : \t\t%6.0f\n'                  ,sum(ind_violate~=0));
fprintf('x| hyper sensitivity: \t\t%6.0f\n'                  ,sum(ind_hS~=0));
fprintf('xm != xd:          \t\t%6.0f\n'                  ,sum(ind_xd~=0));
fprintf('xm != xref:        \t\t%6.0f\n'                  ,sum(ind_xref~=0));
fprintf('xd != xref:        \t\t%6.0f\n'                  ,sum(ind_xdref~=0));
fprintf('large d2x/dS2:     \t\t%6.0f\n'                  ,sum(ind_d2xds2~=0));
fprintf('ssind>3e4:         \t\t%6.0f\n'                  ,sum(ind_ssind~=0));
fprintf('errflg:            \t\t%6.0f\n'                  ,sum(ind_errflr~=0));
fprintf('tmp:               \t\t%6.0f\n'                  ,sum(ind_tmp~=0));
fprintf('total exc:         \t\t%6.0f/%.0f\t(%.0f%%)\n'   ,sum(ind~=0),totResult,100*sum(ind~=0)/totResult);
for indfn = 1:size(fnlst,1)
    fn                      = fnlst{indfn};
    RR.(fn)(ind~=0,:)   = [];
end

clearvars -except RR ind
%% save result
st=input('save to a result file?\n','s');
if strcmp(st,'yes')
    [~,fdn,~]=fileparts(pwd);
    save(sprintf('../%s.mat',fdn),'RR')
    fprintf(sprintf('saved to %s.mat\n',fdn));
end
% 
% clearvars -except RR Nth P0 dataStructVer

