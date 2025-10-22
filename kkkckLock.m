function [LCK] = kkkckLock(indSam,type)

    if ~exist('type','var')
        type=1;
    end
    if type==1
        lockfn  = sprintf('pool%d.txt',indSam);
    elseif type==2
        lockfn  = sprintf('chk%d.txt',indSam);
    end

    LCK=0;
    lastwarn('','');
    try
        delete(lockfn);
    catch
        LCK=1;
    end
    [wmsg,~]=lastwarn;
    if ~isempty(wmsg)
        LCK=1;
    end
    lastwarn('','');
end

