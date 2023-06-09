function [filter] = ctana_submeso_filter(field,lowpass,highpass,grd,filterswitch)

%% ctana_submeso_filter: set up filter structure for filtering and plotting
% [filter] = ctana_submeso_filter(field,length,width,grd,filterswitch)
%
%   INPUTS: field: 2d field to be filtered
%           lowpass: lowpass threshold in km
%           highpass: highpass threshold in km
%           grd
%           filterswitch = 0; time-filtering (needs higher dimensional field)
%           filterswitch = 1; spatial (uses a gaussian convolution matrix
%           where length = lowpass; width = highpass
%           filterswitch = 2; fourier filtering
%
%   OUTPUTS: filter.field = original field
%            filter.mesofield = lowpass field
%            filter.submesofield = highpas field
%            filter.mask = 2d mask for plotting
%
% Example: submeso_filter(field,60,60,grd,2)

index = find(isnan(field));
[a space b c] = ctmisc_mean_grid_spacing(grd); space = space/1000;

if filterswitch == 0
    mesofield = field(:,:,2)/2 + (field(:,:,1)+field(:,:,3))/2;
    submesofield = field(:,:,2) - mesofield;
    field = field(:,:,2);
    
    %Mcwilliams paper carries out smoothing iterations?
    %mesofield = smooth2d(mesofield,width);
    field(index)=0;submesofield(index)=0;mesofield(index)=0;
    
    [~, ~] = ctana_fourier2d(field,mesofield,submesofield,space,0);
    
elseif filterswitch == 1
    %filter = fspecial('gaussian',length,width);
    %field(index) = 0;
    
    l = round(lowpass/space); w = round(highpass/space);
    H=fspecial('gaussian',l,w);%gaussian low pass filter at ~70km, each grid size as 1.6km
    %hao's filter for labrador sea
    %length = 151; width = 0.2*29;
    %mesofield=imfilter(field,H(length/2-15:length/2+15,length/2-15:length/2+15),'conv');
    mesofield=imfilter(field,H,'conv');
    field(index) = 0; mesofield(index) = 0;
    submesofield = field - mesofield;
    [~, ~] = ctana_fourier2d(field,mesofield,submesofield,space,0);
    
elseif filterswitch == 2
    field(index) = 0;
    %low = length/space; hi = width/space;
    [mesofield, submesofield] = ctana_fourier2d(field,lowpass,highpass,space,1);
end

if size(field)~=size(grd.h)
    grd.maskf = grd.maskp;
else
    grd.maskf = grd.maskr;
end

grd.maskf(index) = NaN;

filter.field = field; filter.submesofield = submesofield;
filter.mesofield = mesofield; filter.mask = grd.maskf;
end

