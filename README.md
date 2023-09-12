
# regexp_outkeys documentation
[![View regexp_outkeys on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/76835-regexp_outkeys)
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=thrynae/regexp_outkeys)


Table of contents

- Description section:
- - [Description](#description)
- Matlab/Octave section:
- - [Syntax](#syntax)
- - [Output arguments](#output-arguments)
- - [Input arguments](#input-arguments)
- - [Examples](#examples)
- - [Compatibility, version info, and licence](#compatibility-version-info-and-licence)

## Description

This function extends the `regexp` function for old Matlab releases.  
On older versions of Matlab the `regexp` function did not allow you to specify the output keys. This function has an implementation of the split, match, and tokens output keys, so they can be used on any version of Matlab or GNU Octave.

Note that the builtin regexp function is still used, so any limitation and bugs still apply. As an example; the lookaround assertions (`(?<=test)expr` etc) were introduced in v7 (R14) and are therefore not supported in this function either on v6.5.

## Matlab/Octave

### Syntax

    out = regexp_outkeys(str,expression,outkey);
    [out1,...,outN] = regexp_outkeys(str,expression,outkey1,...,outkeyN);
    [___,startIndex] = regexp_outkeys(___);
    [___,startIndex,endIndex] = regexp_outkeys(___);

### Output arguments

|Argument|Description|
|---|---|
|out|The result specified by the outkey:<br>`'start'`: numeric array with the starting indices of the matches.<br>`'end'`: numeric array with the ending indices of the matches.<br>`'match'`: cellstr with the matches.<br>`'split'`: cellstr with the non-matches.<br>`'tokens'`: nested cellstr with the matched tokens.|
|startIndex|Same result as `'start'` outkey.|
|endIndex|Same result as `'end'` outkey.|

### Input arguments

|Argument|Description|
|---|---|
|str|A `char` array containing the text to be searched.|
|expression|Regular expression. See the documentation for `regexp` for more explanation.|
|outkey|One of the supported outkeys: `'match'`, `'split'`, `'tokens'`, `'start'`, and `'end'`. Duplicates are allowed.|

### Examples
A few examples of valid syntax options:

    str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
    words = regexp_outkeys(str,' ','split')
    numbers = regexp_outkeys(str,'[0-9.]*','match')
    RawTokens = regexp_outkeys(str,'([a-z]+)[0-9]','tokens');
    words_with_number = horzcat(RawTokens{:})
    [white,end1,start,end2] = regexp_outkeys(str,' ','match','end')

### Compatibility, version info, and licence
Compatibility considerations:
- Only the `'match'`, `'split'`, `'tokens'`, `'start'`, and `'end'` options are supported. The additional options provided by `regexp` are also not implemented.
- Cell array input is not supported.

|Test suite result|Windows|Linux|MacOS|
|---|---|---|---|
|Matlab R2022b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2022a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2021b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2021a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2020b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2020a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2019b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2019a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2018a|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it></it>|
|Matlab R2017b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2016b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2015a|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it></it>|
|Matlab R2013b|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2007b|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab 6.5 (R13)|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 8.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 7.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 6.2.0|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Catalina : Pass</it>|
|Octave 5.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 4.4.1|<it>W11 : Pass</it>|<it></it>|<it>Catalina : Pass</it>|

    Version: 2.0.0.1
    Date:    2023-09-12
    Author:  H.J. Wisselink
    Licence: CC by-nc-sa 4.0 ( https://creativecommons.org/licenses/by-nc-sa/4.0 )
    Email = 'h_j_wisselink*alumnus_utwente_nl';
    Real_email = regexprep(Email,{'*','_'},{'@','.'})

### Test suite

The tester is included so you can test if your own modifications would introduce any bugs. These tests form the basis for the compatibility table above. Note that functions may be different between the tester version and the normal function. Make sure to apply any modifications to both.
