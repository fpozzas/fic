% P1 : Huffman
%%%%%%%%%%%%%%

longfile = 'lorem_big.txt'; % Firsts paragraphs of Lorem Ipsum plus some random alphanumeric characters
shortfile = 'lorem_short.txt'; % Another paragraph of Lorem Ipsum

% Code generation
[l,C]=huffman(longfile,'results');
l
C

% Encoding
[sym,pvector] = probcalc(shortfile);
stream = textread(shortfile,'%c');
huff_sym = [C{:,1}]';
pos_code = arrayfun(@(x)(find(x==huff_sym)),stream);
encoded = {C{pos_code,2}}';

if (length(pos_code)~=length(stream))
    disp('WARNING: Some characters haven''t been encoded.');
end;

% Results
pos_sym = arrayfun(@(x)(find(x==huff_sym)),sym);
l_shortfile = l(pos_sym);
lsym=length(sym)
selfinf = -log2(pvector);
entropy = sum(pvector.*selfinf);
% Huffman
efficiency = entropy/sum(l_shortfile.*pvector);
% Fixed-length
nbits = ceil(log2(length(sym)));
fl_efficiency = entropy/sum(nbits*pvector);
disp('%%%% Results of the encoded text: %%%%');
disp('%%% With Huffman: ');
disp(['% Efficiency: ' num2str(efficiency)]);
disp(['% Redundancy: ' num2str(1-efficiency)]);
disp('%%% With a fixed-length code:');
disp(['% Efficiency: ' num2str(fl_efficiency)]);
disp(['% Redundancy: ' num2str(1-fl_efficiency)]);
disp('%%%%%% end of encoded text results %%%%%% ');


