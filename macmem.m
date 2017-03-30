function [] = macmem()
clc;

% [usr, sys] = memory;
% [M,X,C] = inmem
% [M,X,C] = inmem('-completenames')

% [SYSRAM.pso,SYSRAM.ps] = system('ps -caxm -orss,comm','-echo');
% [SYSRAM.vmo,SYSRAM.vm] = system('vm_stat','-echo');
[SYSRAM.pso,SYSRAM.ps] = system('ps -caxm -orss,comm');
[SYSRAM.vmo,SYSRAM.vm] = system('vm_stat');

[TXTmatch,TXTnon] = strsplit(SYSRAM.ps,{'[0-9]+\S '},'CollapseDelimiters',true,'DelimiterType','RegularExpression');
NumArray = str2num([TXTnon{1,:}])';
memSum = sum(NumArray);

rExp = '(Pages free:\W+[0-9]+)|(Pages active:\W+[0-9]+)|(Pages inactive:\W+[0-9]+)|(Pages wired down:\W+[0-9]+)';

[expMat, expNom] = regexpi(SYSRAM.vm,rExp,'match');

PagesFreeRe = deblank(expMat{1}(1:12));
PagesFreeKb = str2num(strtrim(expMat{1}(end-15:end))) *4096/1024/1024/1024;
PagesActiRe = deblank(expMat{2}(1:12));
PagesActiKb = str2num(strtrim(expMat{2}(end-15:end))) *4096/1024/1024/1024;
PagesInacRe = deblank(expMat{3}(1:12));
PagesInacKb = str2num(strtrim(expMat{3}(end-15:end))) *4096/1024/1024/1024;
PagesWireRe = deblank(expMat{4}(1:12));
PagesWireKb = str2num(strtrim(expMat{4}(end-15:end))) *4096/1024/1024/1024;


TopProc = [TXTmatch{1:5}];
TopPrc = strsplit(TopProc,{'\n'},'CollapseDelimiters',true,'DelimiterType','RegularExpression');
TopPrc = TopPrc';

TopMem = num2str([NaN;NumArray(1:5)./1024./1024]); TopMem(1,1:end) = blanks(size(TopMem(1,1:end),2));
TopPr = char(TopPrc);


fprintf('\n------------------------------------------\n')
fprintf('--    TOP PROCESSES  \n\n')
for nn=2:size(TopMem,1)-1
fprintf('  % s      %s Gb \n', TopPr(nn,1:end), TopMem(nn,1:6))
end
fprintf('\n------------------------------------------\n')
fprintf('--    RAM USEAGE  \n')
% warning off backtrace
% warning off verbose
% warning('--    RAM USEAGE')
fprintf('\n        Free     RAM: % .2f Gb ', PagesFreeKb)
fprintf('\n        Active   RAM: % .2f Gb ', PagesActiKb)
fprintf('\n        Inactive RAM: % .2f Gb ', PagesInacKb)
fprintf('\n        Wired    RAM: % .2f Gb ', PagesWireKb)
fprintf('\n        TOT REAL MEM: % .2f Gb \n', memSum/1024/1024)
fprintf('------------------------------------------\n')

end