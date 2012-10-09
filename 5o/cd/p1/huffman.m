function [l,C] = huffman(textfile,opt)
% function [l,C] = huffman(textfile)
% function [l,C] = huffman(textfile,'results')
% Input:
% - textfile : Text file
% - option 'results' : Show results
% Output:
% - l : Length of each char code
% - C : Char and associated code

% Probabilities
[sym,pvector] = probcalc(textfile);
old_pvector = pvector;

% Huffman - Forward phase
oldindexes = zeros(length(sym)-1,1);
for i=1:length(sym)-1
    % Getting and merging the lower probabilities
    sumlessers = sum(pvector(1:2));
    pvector = pvector(3:end);
    % Inserting new probability into vector
    posinsert = sum(sumlessers>pvector)+1;
    pvector = [pvector(1:(posinsert-1)) ; sumlessers ; pvector(posinsert:end)];
    % Saving index for the backward phase
    oldindexes(i) = posinsert;
end 

% Huffman - Backward phase
codes = cell(1);
for i=(length(sym)-1):-1:1
    codes = {strcat(codes{oldindexes(i)},'1') strcat(codes{oldindexes(i)},'0') codes{1:(oldindexes(i)-1)} codes{(oldindexes(i)+1):end}}';
end

% Return parameters
C = [cellstr(sym) , codes];
l = cellfun('length',codes);

%% Results display

if (nargin>1) && strcmp(opt,'results')
    selfinf = -log2(old_pvector);
    entropy = sum(old_pvector.*selfinf);
    % Huffman
    efficiency = entropy/sum(l.*old_pvector);
    % Fixed-length
    nbits = ceil(log2(length(sym)));
    fl_efficiency = entropy/sum(nbits*old_pvector);
    disp('%%%% huffman() function results: %%%%');
    disp('%% Word length VS Self-information:');
    VS = [l , selfinf]
    disp('%%% Huffman: ');
    disp(['% Efficiency: ' num2str(efficiency)]);
    disp(['% Redundancy: ' num2str(1-efficiency)]);
    disp('%%% With a fixed-length code:');
    disp(['% Efficiency: ' num2str(fl_efficiency)]);
    disp(['% Redundancy: ' num2str(1-fl_efficiency)]);
    disp('%%%%%% end of huffman() function results %%%%%% ');
    disp(' ');
end


