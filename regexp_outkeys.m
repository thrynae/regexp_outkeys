function varargout=regexp_outkeys(str,expression,varargin)
%Regexp with outkeys in old releases
%
% On older versions of Matlab the regexp function did not allow you to specify the output keys.
% This function has an implementation of the 'split', 'match', and 'tokens' output keys, so they
% can be used on any version of Matlab or GNU Octave. The 'start' and 'end' output keys were
% already supported as trailing outputs, but are now also explictly supported.
% On releases where this is possible, the builtin is called.
%
% Syntax:
%   out = regexp_outkeys(str,expression,outkey);
%   [out1,...,outN] = regexp_outkeys(str,expression,outkey1,...,outkeyN);
%   [___,startIndex] = regexp_outkeys(___);
%   [___,startIndex,endIndex] = regexp_outkeys(___);
%
% Example:
%  str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
%  words = regexp_outkeys(str,'[ 0-9.]+','split')
%  numbers = regexp_outkeys(str,'[0-9.]*','match')
%  [white,end1,start,end2] = regexp_outkeys(str,' ','match','end')
%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%|                                                                         |%
%|  Version: 2.0.0.1                                                       |%
%|  Date:    2023-09-12                                                    |%
%|  Author:  H.J. Wisselink                                                |%
%|  Licence: CC by-nc-sa 4.0 ( creativecommons.org/licenses/by-nc-sa/4.0 ) |%
%|  Email = 'h_j_wisselink*alumnus_utwente_nl';                            |%
%|  Real_email = regexprep(Email,{'*','_'},{'@','.'})                      |%
%|                                                                         |%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%
% Tested on several versions of Matlab (ML 6.5 and onward) and Octave (4.4.1 and onward), and on
% multiple operating systems (Windows/Ubuntu/MacOS). You can see the full test matrix below.
% Compatibility considerations:
% - Only the 'match', 'split', 'tokens', 'start', and 'end' options are supported. The additional
%   options provided by regexp are not implemented.
% - Cell array input is not supported.
%
% /=========================================================================================\
% ||                     | Windows             | Linux               | MacOS               ||
% ||---------------------------------------------------------------------------------------||
% || Matlab R2022b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2022a       | W11: Pass           |                     |                     ||
% || Matlab R2021b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2021a       | W11: Pass           |                     |                     ||
% || Matlab R2020b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2020a       | W11: Pass           |                     |                     ||
% || Matlab R2019b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2019a       | W11: Pass           |                     |                     ||
% || Matlab R2018a       | W11: Pass           | Ubuntu 22.04: Pass  |                     ||
% || Matlab R2017b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2016b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2015a       | W11: Pass           | Ubuntu 22.04: Pass  |                     ||
% || Matlab R2013b       | W11: Pass           |                     |                     ||
% || Matlab R2007b       | W11: Pass           |                     |                     ||
% || Matlab 6.5 (R13)    | W11: Pass           |                     |                     ||
% || Octave 8.2.0        | W11: Pass           |                     |                     ||
% || Octave 7.2.0        | W11: Pass           |                     |                     ||
% || Octave 6.2.0        | W11: Pass           | Ubuntu 22.04: Pass  | Catalina: Pass      ||
% || Octave 5.2.0        | W11: Pass           |                     |                     ||
% || Octave 4.4.1        | W11: Pass           |                     | Catalina: Pass      ||
% \=========================================================================================/

if nargin<2
    error('HJW:regexp_outkeys:SyntaxError',...
        'No supported syntax used: at least 3 inputs expected.')
    % As an undocumented feature this can also return s1,s2 without any outkeys specified.
end
if ~(ischar(str) && ischar(expression))
    % The extra parameters in varargin are checked inside the loop.
    error('HJW:regexp_outkeys:InputError',...
        'All inputs must be char vectors.')
end
if nargout>nargin
    error('HJW:regexp_outkeys:ArgCount',...
        'Incorrect number of output arguments. Check syntax.')
end

persistent legacy errorstr KeysDone__template
if isempty(legacy)
    % The legacy struct contains the implemented options as field names. It is used in the error
    % message.
    % It is assumed that all Octave versions later than 4.0 support the expanded output, and all
    % earlier versions do not, even if it is very likely most versions will support it.
    
    % Create these as fields so they show up in the error message.
    legacy.start = true;
    legacy.end = true;
    
    % The switch to find matches was introduced in R14 (along with the 'tokenExtents', 'tokens'
    % and 'names' output switches).
    legacy.match = ifversion('<','R14','Octave','<',4);
    legacy.tokens = legacy.match;
    
    % The split option was introduced in R2007b.
    legacy.split = ifversion('<','R2007b','Octave','<',4);
    
    fn = fieldnames(legacy);
    errorstr = ['Extra regexp output type not implemented,',char(10),'only the following',...
        ' types are implemented:',char(10),sprintf('%s, ',fn{:})]; %#ok<CHARTEN>
    errorstr((end-1):end) = ''; % Remove trailing ', '
    
    legacy.any = legacy.match || legacy.split || legacy.tokens;
    
    % Copy all relevant fields and set them to false.
    KeysDone__template = legacy;
    for x=fieldnames(KeysDone__template).',KeysDone__template.(x{1}) = false;end
end

if legacy.any || nargin==2 || any(ismember(lower(varargin),{'start','end'}))
    % Determine s1, s2, and TokenIndices only once for the legacy implementations.
    [s1,s2,TokenIndices] = regexp(str,expression);
end

if nargin==2
    varargout = {s1,s2,TokenIndices};return
end

% Pre-allocate output.
varargout = cell(size(varargin));
done = KeysDone__template; % Keep track of outkey in case of repeats.
% On some releases the Matlab is not convinced split is a variable, so explicitly assign it here.
split = [];
for param=1:(nargin-2)
    if ~ischar(varargin{param})
        error('HJW:regexp_outkeys:InputError',...
            'All inputs must be char vectors.')
    end
    switch lower(varargin{param})
        case 'match'
            if done.match,varargout{param} = match;continue,end
            if legacy.match
                % Legacy implementation.
                match = cell(1,numel(s1));
                for n=1:numel(s1)
                    match{n} = str(s1(n):s2(n));
                end
            else
                [match,s1,s2] = regexp(str,expression,'match');
            end
            varargout{param} = match;done.match = true;
        case 'split'
            if done.split,varargout{param} = split;continue,end
            if legacy.split
                % Legacy implementation.
                split = cell(1,numel(s1)+1);
                start_index = [s1 numel(str)+1];
                stop_index = [0 s2];
                for n=1:numel(start_index)
                    split{n} = str((stop_index(n)+1):(start_index(n)-1));
                    if numel(split{n})==0,split{n} = char(ones(0,0));end
                end
            else
                [split,s1,s2] = regexp(str,expression,'split');
            end
            varargout{param}=split;done.split = true;
        case 'tokens'
            if done.tokens,varargout{param} = tokens;continue,end
            if legacy.tokens
                % Legacy implementation.
                tokens = cell(numel(TokenIndices),0);
                for n=1:numel(TokenIndices)
                    if size(TokenIndices{n},2)~=2
                        % No actual matches for the tokens.
                        tokens{n} = cell(1,0);
                    else
                        for m=1:size(TokenIndices{n},1)
                            tokens{n}{m} = str(TokenIndices{n}(m,1):TokenIndices{n}(m,2));
                        end
                    end
                end
            else
                [tokens,s1,s2] = regexp(str,expression,'tokens');
            end
            varargout{param} = tokens;done.tokens = true;
        case 'start'
            varargout{param} = s1;
        case 'end'
            varargout{param} = s2;
        otherwise
            error('HJW:regexp_outkeys:NotImplemented',errorstr)
    end
end
if nargout>param
    varargout(param+[1 2]) = {s1,s2};
end
end
function tf=ifversion(test,Rxxxxab,Oct_flag,Oct_test,Oct_ver)
%Determine if the current version satisfies a version restriction
%
% To keep the function fast, no input checking is done. This function returns a NaN if a release
% name is used that is not in the dictionary.
%
% Syntax:
%   tf = ifversion(test,Rxxxxab)
%   tf = ifversion(test,Rxxxxab,'Octave',test_for_Octave,v_Octave)
%
% Input/output arguments:
% tf:
%   If the current version satisfies the test this returns true. This works similar to verLessThan.
% Rxxxxab:
%   A char array containing a release description (e.g. 'R13', 'R14SP2' or 'R2019a') or the numeric
%   version (e.g. 6.5, 7, or 9.6). Note that 9.10 is interpreted as 9.1 when using numeric input.
% test:
%   A char array containing a logical test. The interpretation of this is equivalent to
%   eval([current test Rxxxxab]). For examples, see below.
%
% Examples:
% ifversion('>=','R2009a') returns true when run on R2009a or later
% ifversion('<','R2016a') returns true when run on R2015b or older
% ifversion('==','R2018a') returns true only when run on R2018a
% ifversion('==',9.14) returns true only when run on R2023a
% ifversion('<',0,'Octave','>',0) returns true only on Octave
% ifversion('<',0,'Octave','>=',6) returns true only on Octave 6 and higher
% ifversion('==',9.10) returns true only when run on R2016b (v9.1) not on R2021a (9.10).
%
% The conversion is based on a manual list and therefore needs to be updated manually, so it might
% not be complete. Although it should be possible to load the list from Wikipedia, this is not
% implemented.
%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%|                                                                         |%
%|  Version: 1.2.0                                                         |%
%|  Date:    2023-04-06                                                    |%
%|  Author:  H.J. Wisselink                                                |%
%|  Licence: CC by-nc-sa 4.0 ( creativecommons.org/licenses/by-nc-sa/4.0 ) |%
%|  Email = 'h_j_wisselink*alumnus_utwente_nl';                            |%
%|  Real_email = regexprep(Email,{'*','_'},{'@','.'})                      |%
%|                                                                         |%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%
% Tested on several versions of Matlab (ML 6.5 and onward) and Octave (4.4.1 and onward), and on
% multiple operating systems (Windows/Ubuntu/MacOS). For the full test matrix, see the HTML doc.
% Compatibility considerations:
% - This is expected to work on all releases.

if nargin<2 || nargout>1,error('incorrect number of input/output arguments'),end

% The decimal of the version numbers are padded with a 0 to make sure v7.10 is larger than v7.9.
% This does mean that any numeric version input needs to be adapted. multiply by 100 and round to
% remove the potential for float rounding errors.
% Store in persistent for fast recall (don't use getpref, as that is slower than generating the
% variables and makes updating this function harder).
persistent  v_num v_dict octave
if isempty(v_num)
    % Test if Octave is used instead of Matlab.
    octave = exist('OCTAVE_VERSION', 'builtin');
    
    % Get current version number. This code was suggested by Jan on this thread:
    % https://mathworks.com/matlabcentral/answers/1671199#comment_2040389
    v_num = [100, 1] * sscanf(version, '%d.%d', 2);
    
    % Get dictionary to use for ismember.
    v_dict = {...
        'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;
        'R14SP3' 701;'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;
        'R2008a' 706;'R2008b' 707;'R2009a' 708;'R2009b' 709;'R2010a' 710;
        'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
        'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;
        'R2015b' 806;'R2016a' 900;'R2016b' 901;'R2017a' 902;'R2017b' 903;
        'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;'R2020a' 908;
        'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;
        'R2023a' 914};
end

if octave
    if nargin==2
        warning('HJW:ifversion:NoOctaveTest',...
            ['No version test for Octave was provided.',char(10),...
            'This function might return an unexpected outcome.']) %#ok<CHARTEN>
        if isnumeric(Rxxxxab)
            v = 0.1*Rxxxxab+0.9*fixeps(Rxxxxab);v = round(100*v);
        else
            L = ismember(v_dict(:,1),Rxxxxab);
            if sum(L)~=1
                warning('HJW:ifversion:NotInDict',...
                    'The requested version is not in the hard-coded list.')
                tf = NaN;return
            else
                v = v_dict{L,2};
            end
        end
    elseif nargin==4
        % Undocumented shorthand syntax: skip the 'Octave' argument.
        [test,v] = deal(Oct_flag,Oct_test);
        % Convert 4.1 to 401.
        v = 0.1*v+0.9*fixeps(v);v = round(100*v);
    else
        [test,v] = deal(Oct_test,Oct_ver);
        % Convert 4.1 to 401.
        v = 0.1*v+0.9*fixeps(v);v = round(100*v);
    end
else
    % Convert R notation to numeric and convert 9.1 to 901.
    if isnumeric(Rxxxxab)
        % Note that this can't distinguish between 9.1 and 9.10, and will the choose the former.
        v = fixeps(Rxxxxab*100);if mod(v,10)==0,v = fixeps(Rxxxxab)*100+mod(Rxxxxab,1)*10;end
    else
        L = ismember(v_dict(:,1),Rxxxxab);
        if sum(L)~=1
            warning('HJW:ifversion:NotInDict',...
                'The requested version is not in the hard-coded list.')
            tf = NaN;return
        else
            v = v_dict{L,2};
        end
    end
end
switch test
    case '==', tf = v_num == v;
    case '<' , tf = v_num <  v;
    case '<=', tf = v_num <= v;
    case '>' , tf = v_num >  v;
    case '>=', tf = v_num >= v;
end
end
function val=fixeps(val)
% Round slightly up to prevent rounding errors using fix().
val = fix(val+eps*1e3);
end

