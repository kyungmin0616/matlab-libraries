function catpreview(epsFilename,tifFilename,preFilename)
%CATPREVIEW Creates an EPS/TIFF preview file.
%CATPREVIEW(PRINTOBJ,EPSFILENAME,TIFFFILENAME,PREFILENAME)
%   PRINTJOBOBJ  - Instance of printjob object
%   EPSFILENAME  - name of the EPS file
%   TIFFFILENAME - name of the TIFF preview file
%   PREFILENAME  - name of the resulting preview file
%   
%   Deletes the EPS and TIFF files when done unless PrintJob.DebugMode is true.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1999/01/15 18:02:22 $

if ~exist(epsFilename)
    error( 'No EPS file to concatenate.' )
end
if ~exist(tifFilename)
    error( 'No TIFF file to concatenate.' )
end

hdrFilename=LocMakeHeader(epsFilename,tifFilename);

pFID=fopen(preFilename,'w');
if pFID>0
    %Just checking that I could write to it, get rid of it.
    fclose(pFID);
    delete(preFilename)
    
    if isunix | isvms
        [Status, result] = unix(['cat  "' hdrFilename '" "', ...
                epsFilename,'" "' tifFilename '" > "' preFilename '"']);   
    elseif strncmp(computer,'PC',2)
        %[Status, result] = dos( pj, ['copy /B "' hdrFilename '" +"', ...
        %        epsFilename,'" /B +"' tifFilename '" "' preFilename '"']);
    elseif strncmp(computer,'MAC',3)
        %error('Multiple file copying not supported on MAC');
    end % if computer type
else
    error(['Could not open file ' preFilename])
end

%    delete(epsFilename);
%    delete(tifFilename);
    delete(hdrFilename);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hdrFilename=LocMakeHeader(epsFilename,tifFilename);
%creates EPS preview header

epsCount=dir(epsFilename);
epsCount=epsCount.bytes;
tifCount=dir(tifFilename);
tifCount=tifCount.bytes;

epsHeader=[197 208 211 198 ...  %Header
      30 00 00 00 ... %PostScript file Start
      dec2pairs(epsCount) ... %PostScript length
      00 00 00 00 ... %Metafile start
      00 00 00 00 ... %Metafile length 
      dec2pairs(epsCount+30) ... %TIFF start
      dec2pairs(tifCount) ... %TIFF length
      255 255];  %footer

hdrFilename=[tempname '.hdr'];
hFID=fopen(hdrFilename,'w');
if hFID>0
   fwrite(hFID,epsHeader,'uchar');
   fclose(hFID);
else
   error(['Could not write header file to ' hdrFilename]);
end

%%%%%%%%%%%%%%%%%%%%%%%
function s=dec2pairs(d);
%converts Base10 decimal numbers to base 256 hex pairs
%note that this function flips the order of the resulting
%pairs.

base = 256;
nreq = ceil(log2(max(d) + 1)/log2(base)); 

n=4;
nreq = max(nreq,1);
n = max(n,nreq);
last = n - nreq + 1;

s(:,n) = rem(d,base);
while n ~= last
   n = n - 1;
   d = floor(d/base);
   s(:,n) = rem(d,base);
end

symbols=[0:255];
s = reshape(symbols(s + 1),size(s));

%flip order
s=s(end:-1:1);
