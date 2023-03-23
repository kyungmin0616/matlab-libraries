function lprf(file, varargin)

%clf;rnc_map(sstn.mean, sstn, 1);

%ysplit=11/5; % time series
ysplit=11/4.5; % time series
%ysplit=11/6; % map plots
%ysplit=11/7; % tropics map plot
%ysplit=11/2; % 2 vertical1 column
%ysplit=11/6; % 2 vertical1 column

xsplit=8.5/2;
xsplit=0.25+3.375;
%xsplit=8.5-0.75; xsplit=xsplit*0.75;
AUTO=0;
nargin
if nargin > 1
    if length(varargin) == 2
        xsplit=varargin{1};
        ysplit=varargin{2};
    else
        AUTO=1;
    end
end
AUTO
p=[0.25 0.25 xsplit ysplit	];
if AUTO == 0
    disp('Setting paper position ...');
    set(gcf, 'paperposition',p);
    [xsplit, ysplit]
end

%rnt_font('terminal',10);
%set(gcf, 'Linewidth', 0.2);
set(gca,'Linewidth', 1)
set(gca,'Layer', 'top')
%rnt_font('helvetica',8);
%set(gca,'TickDir','out','XMinorTick','on','YMinorTick','on');
%set(gca,'TickDir','out','YMinorTick','on');


%lpr(['/sdd/web/temp/Figures/',file]);
%lpr(['/nas/edl/Figures/',file]);
lpr(file);
%lpr(['/nv/pe1/ed70/jets/figures/',file]);
%lpr(['/sdd/web/temp/',file]);
return

pac.xlim=[-326  -64.0553];
pac.ylim=[-50 65];
p=pac;trange=[datenum(1950, 1,15) datenum(2008, 12, 15)];

sstn=rnc_Extract_NOAA_SST(p.xlim,p.ylim,trange,0);
sstn = rnc_forcdStats(sstn,'SST',  [1950 2008]);
sstn.time=sstn.datenum;

%/dods/matlib/rnt/util/red_signi.m
