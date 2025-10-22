function [] = setpolltxt(totBatch)
%
%   creating "pool" file for potential parallel running of disParrSim.m
%
%
%
    if ~exist('totBatch','var')
        totBatch=10000;
    end
    for ind=1:totBatch
        fid=fopen(sprintf('pool%.0f.txt',ind),'w');
        fclose(fid);
        fid=fopen(sprintf('chk%.0f.txt',ind),'w');
        fclose(fid);
    end
end

