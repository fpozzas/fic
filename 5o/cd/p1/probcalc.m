function [ sym,pvector ] = probcalc(textfile)
% function [ sym,pvector ] = probcalc(textfile)
% Input:
% - textfile : Text file including ASCII characters
% Output:
% - sym : characters/symbols from the text file ordered by ascendent probability
% - pvector: probability's vector

% Text read
stream = textread(textfile,'%c');
% Probabilities
sstream = sort(stream);
[sym,first,] = unique(sstream,'first');
[sym,last,] = unique(sstream,'last');
sumsym = last-first+1;
pvector = sumsym/length(sstream);
% Order by probabilities (ascendent)
[pvector,index] = sort(pvector);
sym = sym(index);

end

