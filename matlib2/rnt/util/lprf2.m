function lprf2(file, varargin)

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

AUTO=1;

p=[0.25 0.25 xsplit ysplit	];
if AUTO == 0
    disp('Setting paper position ...');
    set(gcf, 'paperposition',p);
    [xsplit, ysplit]
end

rnt_font('terminal',10);
%set(gcf, 'Linewidth', 0.2);
%set(gca,'Linewidth', 1)
%set(gca,'Layer', 'top')
%rnt_font('Helvetica',10);
%set(gca,'TickDir','out','XMinorTick','on','YMinorTick','on');
%set(gca,'TickDir','out','YMinorTick','on');


lpr(['/nas/edl/Figures/',file]);
%lpr(['/nas/edl/Figures/',file]);
%lpr(file);
%lpr(['/nas/edl/Figures/tmp.eps']);
%lpr(['/nv/pe1/ed70/jets/figures/',file]);
%lpr(['/sdd/web/temp/',file]);
return
