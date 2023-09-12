function pass_part_fail=aaa___regexp_outkeys___test(varargin)
%Test the supported output keys by comparing the output to pre-computed hashes.
%
%Pass:    passes all tests
%Partial: [no partial passing condition]
%Fail:    fails any test
pass_part_fail = 'pass';

SelfTestFailMessage = '';
% Run the self-validator function(s).
SelfTestFailMessage = [SelfTestFailMessage SelfTest__regexp_outkeys];
checkpoint('read');

% This function does not contain a real test suite other than the self-validator.
if ~isempty(SelfTestFailMessage)
    if nargout>0
        pass_part_fail = 'fail';
    else
        error('Self-validator functions returned these error(s):\n%s',SelfTestFailMessage)
    end
end
disp(['tester function ' mfilename ' finished '])
if nargout==0,clear,end
end
function v000=ifversion(v001,v002,v003,v004,v005),if nargin<2||nargout>1,...
error('incorrect number of input/output arguments'),end,persistent v006 v007 v008,if ...
isempty(v006),v008=exist('OCTAVE_VERSION','builtin');v006=[100,1] * sscanf(version,'%d.%d',2);
v007={'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;'R14SP3' 701;
'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;'R2008a' 706;'R2008b' 707;'R2009a' 708;
'R2009b' 709;'R2010a' 710;'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;'R2015b' 806;'R2016a' 900;
'R2016b' 901;'R2017a' 902;'R2017b' 903;'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;
'R2020a' 908;'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;'R2023a' 914};end,...
if v008,if nargin==2,warning('HJW:ifversion:NoOctaveTest',...
['No version test for Octave was provided.',char(10),...
'This function might return an unexpected outcome.']),if isnumeric(v002),v009=...
0.1*v002+0.9*ifversion_f00(v002);v009=round(100*v009);else,v010=ismember(v007(:,1),v002);if ...
sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,elseif nargin==4,[v001,v009]=deal(v003,v004);v009=0.1*v009+0.9*ifversion_f00(v009);v009=...
round(100*v009);else,[v001,v009]=deal(v004,v005);v009=0.1*v009+0.9*ifversion_f00(v009);v009=...
round(100*v009);end,else,if isnumeric(v002),v009=ifversion_f00(v002*100);if mod(v009,10)==0,...
v009=ifversion_f00(v002)*100+mod(v002,1)*10;end,else,v010=ismember(v007(:,1),v002);if ...
sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,end,switch v001,case'==',v000=v006==v009;case'<',v000=v006 < v009;case'<=',v000=v006 <=...
v009;case'>',v000=v006 > v009;case'>=',v000=v006 >=v009;end,end
function v000=ifversion_f00(v000),v000=fix(v000+eps*1e3);end
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
    
    checkpoint('regexp_outkeys','ifversion')
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
function SelfTestFailMessage=SelfTest__regexp_outkeys
% Run a self-test to ensure the function works as intended.
% This is intended to test internal function that do not have stand-alone testers, or are included
% in many different functions as subfunction, which would make bug regression a larger issue.

checkpoint('SelfTest__regexp_outkeys','regexp_outkeys')
ParentFunction = 'regexp_outkeys';
% This flag will be reset if an error occurs, but otherwise should ensure this test function
% immediately exits in order to minimize the impact on runtime.
if nargout==1,SelfTestFailMessage='';end
persistent SelfTestFlag,if ~isempty(SelfTestFlag),return,end
SelfTestFlag = true; % Prevent infinite recursion.

test_number = 0;ErrorFlag = false;
while true,test_number=test_number+1;
    switch test_number
        case 0 % (test template)
            try ME=[];
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 1
            % Test if all implemented output keys will return a value.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                [val1,val2,val3] = regexp_outkeys(str,'( )','split','match','tokens');
                if isempty(val1) || isempty(val2) || isempty(val3)
                    error('one of the implemented outkeys is empty')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 2
            % Test if adding the start and end indices as outputs does not alter the others.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                [a1,a2,a3,start_,end_] = regexp_outkeys(str,'( )','split','match','tokens');
                [b1,b2,b3] = regexp_outkeys(str,'( )','split','match','tokens');
                if isempty(start_) || isempty(end_) || ...
                        ~isequal(a1,b1) || ~isequal(a2,b2) || ~isequal(a3,b3)
                    error('one of the implemented outkeys is empty')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 3
            % Confirm a regex without tokens will have an empty tokens output.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                NoTokenMatch = regexp_outkeys(str,' ','tokens');
                expected = repmat({cell(1,0)},1,6);
                if ~isequal(NoTokenMatch,expected)
                    error('no tokens in regex did not return empty result')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 4
            % Check the split option, including trailing empty.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                SpaceDelimitedElements = regexp_outkeys(str,' ','split');
                expected = {'lorem1','ipsum1.2','dolor3','sit','amet','99',char(ones(0,0))};
                if ~isequal(SpaceDelimitedElements,expected)
                    error(['space delimited elements did not match expected result' char(10) ...
                        '(perhaps the trailing empty is 1x0 instead of 0x0)']) %#ok<CHARTEN>
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 5
            % Check the split option, including trailing empty.
            try ME=[];
                SpaceDelimitedElements = regexp_outkeys('',' ','split');
                expected = {char(ones(0,0))};
                if ~isequal(SpaceDelimitedElements,expected)
                    size(SpaceDelimitedElements{end}),size(expected{end}),keyboard
                    error('split on empty str did not return 0x0 empty')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 6
            % Check the extraction of a matched pattern.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                RawTokens = regexp_outkeys(str,'([a-z]+)[0-9]','tokens');
                words_with_number = horzcat(RawTokens{:});
                expected = {'lorem','ipsum','dolor'};
                if ~isequal(words_with_number,expected)
                    error('actual results did not match expected result')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 7
            % Check the extraction of a matched pattern.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 9x9 ';
                numbers = regexp_outkeys(str,'[0-9.]*','match');
                expected = {'1','1.2','3','9','9'};
                if ~isequal(numbers,expected)
                    error('actual results did not match expected result')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 8
            % Check the addition of start and end as tokens.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 9x9 ';
                [ignore,end1,start1,end2] = regexp_outkeys(str,' .','match','end'); %#ok<ASGLU>
                [start2,end3] = regexp_outkeys(str,' .');
                expected = [7 16 23 27 32];
                if ~isequal(start1,expected) || ~isequal(start2,expected)
                    error('start indices did not match expectation')
                end
                expected = expected+1;
                if ~isequal(end1,expected) || ~isequal(end2,expected) || ~isequal(end3,expected)
                    error('end indices did not match expectation')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 9
            % Check multi-element tokens.
            [t,s] = regexp_outkeys('2000/12/31','(\d\d\d\d)/(\d\d)/(\d\d)','tokens','split');
            expected1 = {{'2000','12','31'}};
            expected2 = {char(ones(0,0)),char(ones(0,0))};
            if ~isequal(t,expected1) || ~isequal(s,expected2)
                error('result did not match expectation for multiple tokens')
            end
        case 10
            % Check multi-element tokens.
            t = regexp_outkeys('12/34 56/78','(\d\d)/(\d\d)','tokens');
            expected = {{'12','34'},{'56','78'}};
            if ~isequal(t,expected)
                error('result did not match expectation for multiple tokens')
            end
        otherwise % No more tests.
            break
    end
end
if ErrorFlag
    SelfTestFlag = [];
    if isempty(ME)
        if nargout==1
            SelfTestFailMessage=sprintf('Self-validator %s failed on test %d.\n',...
                ParentFunction,test_number);
        else
            error('self-test %d failed',test_number)
        end
    else
        if nargout==1
            SelfTestFailMessage=sprintf(...
                'Self-validator %s failed on test %d.\n   ID: %s\n   msg: %s\n',...
                ParentFunction,test_number,ME.identifier,ME.message);
        else
            error('self-test %d failed\n   ID: %s\n   msg: %s',...
                test_number,ME.identifier,ME.message)
        end
    end
end
end

function out=checkpoint(caller,varargin)
% This function has limited functionality compared to the debugging version.
% (one of the differences being that this doesn't read/write to a file)
% Syntax:
%   checkpoint(caller,dependency)
%   checkpoint(caller,dependency_1,...,dependency_n)
%   checkpoint(caller,checkpoint_flag)
%   checkpoint('reset')
%   checkpoint('read')
%   checkpoint('write_only_to_file_on_read')
%   checkpoint('write_to_file_every_call')

persistent data
if isempty(data)||strcmp(caller,'reset')
    data = struct('total',0,'time',0,'callers',{{}});
end
if strcmp(caller,"read")
    out = data.time;return
end
if nargin==1,return,end
then = now;
for n=1:numel(varargin)
    data.total = data.total+1;
    data.callers = sort(unique([data.callers {caller}]));
    if ~isfield(data,varargin{n}),data.(varargin{n})=0;end
    data.(varargin{n}) = data.(varargin{n})+1;
end
data.time = data.time+ (now-then)*( 24*60*60*1e3 );
data.time = round(data.time);
end

