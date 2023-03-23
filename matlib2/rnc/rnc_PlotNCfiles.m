%function rnc_PlotNCfiles(nameit, outdir)
function rnc_PlotNCfiles(nameit, outdir)

  clmfile=[outdir,nameit,'-clim.nc'];
  bryfile=[outdir,nameit,'-bry.nc'];
  initfile=[outdir,nameit,'-init.nc'];
  forcfile=[outdir,nameit,'-forc.nc'];
  grd=rnt_gridload(nameit);
  
  
  DoPlot=10;
  while DoPlot ~=0
    
    DoPlot =input('Select file: Forcing (1) , Clima (2), Init (3) Stop(0) => ');
    
    if DoPlot ==1
      % Do forcing first
      variables ={'sustr' 'svstr' 'shflux' 'swflux' 'SST' 'SSS' 'dQdSST' 'swrad'}
      
      myvar=input('Select variable =>');
      nc=netcdf(forcfile);
      nc{myvar}
      
      in=input('Time range (1:12) =>');
      clf
      if length(in) > 4
        I=4;
        J=ceil(length(in)/4);
      else
        I=1;
        J=length(in);
      end
      
      for i=1:length(in)
        subplot(I,J,i)
        rnt_plc2( nc{myvar}(in(i),:,:)',grd,2,5,0,0);
        title (num2str(in(i)))
      end
      rnt_font
    end
    
    
    if DoPlot ==2
      % Do Clima first
      variables ={'temp' 'salt' 'u' 'v' 'ubar' 'vbar' 'zeta'}
      
      myvar=input('Select variable =>');
      nc=netcdf(clmfile);
      nc{myvar}
      p=ncsize(nc{myvar});
      if length(p) > 3
        K=input('Vertical Level =>');
      else
        K=0;
      end
      
      in=input('Time range (1:12) =>');
      clf
      if length(in) > 4
        I=4;
        J=ceil(length(in)/4);
      else
        I=1;
        J=length(in);
      end
      
      for i=1:length(in)
        subplot(I,J,i)
        if K ==0
          rnt_plc2( nc{myvar}(in(i),:,:)',grd,2,5,0,0);
        else
          rnt_plc2( nc{myvar}(in(i),K,:,:)',grd,2,5,0,0);
        end
        title (num2str(in(i)))
      end
      rnt_font
    end
    

    if DoPlot ==3
      % Do init
      variables ={'temp' 'salt' 'u' 'v' 'ubar' 'vbar' 'zeta'}
      
      myvar=input('Select variable =>');
      nc=netcdf(initfile);
      nc{myvar}
      p=ncsize(nc{myvar});
      if length(p) > 3
        K=input('Vertical Level =>');
      else
        K=0;
      end
      
      in=input('Time range (1:12) =>');
      clf
      if length(in) > 4
        I=4;
        J=ceil(length(in)/4);
      else
        I=1;
        J=length(in);
      end
      
      for i=1:length(in)
        subplot(I,J,i)
        if K ==0
          rnt_plc2( nc{myvar}(in(i),:,:)',grd,2,5,0,0);
        else
          rnt_plc2( nc{myvar}(in(i),K,:,:)',grd,2,5,0,0);
        end
        title (num2str(in(i)))
      end
      rnt_font
    end
  end
