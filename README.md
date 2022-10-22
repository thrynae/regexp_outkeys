[![View regexp_outkeys on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/76835-regexp_outkeys)

This function extends the regexp function for old Matlab releases.  
On older versions of Matlab the regexp function did not allow you to specify the output keys. This function has an implementation of the split, match, and tokens output keys, so they can be used on any version of Matlab or GNU Octave.

Note that the builtin regexp function is still used, so any limitation and bugs still apply. As an example; the lookaround assertions (`(?<=test)expr` etc) were introduced in v7 (R14).

Licence: CC by-nc-sa 4.0