function [] = distParrSim(nth)
%% INC
% include kkkckLock.m
% include NSrelation.m
%
%
%% 
%
% with the "kkkckLock.m" multuple distPattSim can be run at the same time
% for speed-up. 
% e.g., open 10 matlab threads, running distParrSim(1), ..., distParrSim(10)
% 
%%
    warning('off','all')
    fprintf('start at: %s\n',datetime);
    fprintf('\n');
    fprintf('using distributed parallel (thread:%.0f)\n',nth);
%%
    rng('shuffle');
    s=rng;
    rng(s.Seed+nth);
    s=rng;                                                      % random seed
    SET.seed=s.Seed;                                            % SET is the setting
%% main sampling
    SET.totBatch    = 10000;                                    % total number of parameter samling is totBatch x batchSz
    SET.batchSz     = 10;                                       % number of result save in a dataSamXX.mat file
    SET.Nnode       = 2;                                        % node (dimension) of the simulated network

    [~,batchlst]      = sort(rand(1,SET.totBatch));             % randomizing the rumming order
    for chktype=1:2                                             % ensuring no more than one instance running the same batch
        for indbat = batchlst                                   % id of the current batch
            datafn=sprintf('dataSam%.0f.mat',indbat);           % the result file name
            if kkkckLock(indbat,chktype)||exist(datafn,'file')  % ensuring correct parallel
                continue;
            end
            
            if chktype==1                                       
                fprintf('     ');
            elseif chktype==2
                fprintf('   c|');
            end
            fprintf('%5.0f\t%s',indbat,datetime('now','Format','HH:mm'));
            structR=[];                                         % structR is the result
            structR(SET.batchSz).P  =[];                        % the parameter
            structR(SET.batchSz).OUT=[];                        % the output
            for indsubsam=1:SET.batchSz
                [OUT,P] = NSrelation(SET);                      % main function, see NSrelation.m for explanation of fields in OUT
    
                structR(indsubsam).P        = P;
                structR(indsubsam).OUT      = OUT;
    
                errflg=OUT.errflg;                              % for early debugging purpose, not used anymore...
                fprintf('\t%.0f',errflg);

                if exist(datafn,'file')                         % in early version, sometimes two matlab running the same batch id...
                    break;
                end
            end
    
            if exist(datafn,'file')
                fprintf('\tmat exist!\n')                       % ...
                continue;
            else
                save(datafn,'SET','structR');
            end
            fprintf('\n');
        end
    end
%%
    fprintf('finish at: %s_________________________________________\n',datetime);
end

