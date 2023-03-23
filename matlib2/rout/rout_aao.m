
function aao=rout_aao

data=[1979  0.209  0.356  0.899  0.678  0.724  1.700  2.412  0.546  0.629  0.160 -0.423 -0.951
1980 -0.447 -0.980 -1.424 -2.068 -0.479  0.286 -1.944 -0.997 -1.701  0.577 -2.013 -0.356
1981  0.231  0.039 -0.966 -1.462 -0.344  0.352 -0.986 -2.118 -1.509 -0.260  0.626  1.116
1982 -0.554  0.277  1.603  1.531  0.118  0.920 -0.415  0.779  1.580 -0.702 -0.849 -1.934
1983 -1.340 -1.081  0.166  0.149 -0.437 -0.263  1.114  0.792 -0.696  1.193  0.727  0.475
1984 -1.098 -0.544  0.251 -0.204 -1.237  0.426  0.890 -0.548  0.327 -0.009 -0.024 -1.476
1985 -0.795  0.215 -0.134  0.031 -0.066 -0.331  1.914  0.595  1.507  0.471  1.085  1.240
1986  0.158 -1.588 -0.770 -0.087 -1.847 -0.619  0.089 -0.157  0.849  0.306 -0.222  0.886
1987 -0.950 -0.708 -0.133 -0.286  0.039 -0.702 -1.531  1.485 -0.799  0.455  1.060  0.272
1988 -0.612  0.551 -0.219 -0.077 -0.749 -1.055  0.576 -0.745 -0.689 -2.314  0.401  1.074
1989  0.618  0.849  0.632 -0.573  2.691  1.995  1.458 -0.132 -0.121  0.136  0.572 -0.445
1990 -0.352  1.151  0.414 -1.879 -1.803  0.093 -1.215  0.466  1.482  0.139 -0.359 -0.312
1991  0.869 -0.852  0.522 -0.639 -0.539 -1.155 -1.220  0.036 -0.513 -0.623 -0.804 -2.067
1992  0.073 -1.627 -1.010 -0.439 -2.032 -2.193 -0.566 -0.350  0.435 -0.319  0.122  0.244
1993 -2.021  0.437 -0.378  0.087  1.260  1.218  1.957  1.083  1.061  0.748  0.324  1.028
1994  0.723  1.157  0.693 -0.052 -0.153 -1.682 -0.492  1.910 -0.947 -0.578 -0.793  0.933
1995  1.448  0.533 -0.154  0.649  1.397 -0.802 -3.010 -0.696  1.173 -0.057  0.143  1.470
1996  0.332 -0.525  0.543  0.115  0.983 -0.252  0.021 -1.502 -1.314  0.966 -1.667 -0.023
1997  0.369 -0.244  0.701 -0.458  1.028 -0.458  0.780  0.768  0.122 -0.595 -1.905 -0.835
1998  0.413  0.390  0.736  1.927 -0.038  1.031  1.450  0.904 -0.122  0.400  0.817  1.435
1999  0.999  0.456  0.180  0.949  1.639 -1.325  0.316  0.042 -0.012  1.653  0.901  1.784
2000  1.273  0.620  0.133  0.233  1.127  0.117  0.059 -0.674 -1.853  0.347 -1.537 -1.290
2001 -0.471 -0.265 -0.555  0.515 -0.262  0.386 -0.928  0.910  1.161  1.277  0.996  1.474
2002  0.747  1.334 -1.823  0.165 -2.798 -1.112 -0.591 -0.099 -0.864 -2.564 -0.924  1.308
2003 -0.988 -0.357 -0.188  0.224  0.385 -0.775  0.727  0.678 -0.323 -0.025 -0.712 -1.323
2004  0.807 -1.182  0.432  0.151  0.460  1.195  1.474 -0.071  0.254 -0.042 -0.242 -0.973
2005 -0.129  1.243  0.158  0.355 -0.297 -1.428 -0.252  0.228  0.241  0.031 -0.551 -1.968
2006  0.339 -0.211  0.501 -0.169  1.695  0.438  0.926 -1.727 -0.324  0.879  0.101  0.638
2007 -0.083  0.075 -0.570 -1.035 -0.612 -1.198 -2.631 -0.108  0.031 -0.434 -0.984  1.929
2008  1.208  1.147  0.587 -0.873 -0.490  1.348  0.320  0.087  1.386  1.215  0.920  1.194
2009  0.963  0.456  0.605  0.029 -0.733 -0.470 -1.234 -0.686 -0.017  0.085 -1.915  0.607
2010 -0.757 -0.775  0.108  0.377  1.021  2.071  2.424  1.510  0.402  1.335  1.516  0.205];

years=data(:,1);
k=0;
i=0;
for yr=years(1):years(end)
   i=i+1;
   for imon=1:12
     k=k+1;
     aao.time(k)=datenum(yr,imon,15);
     aao.year(k)=yr;
     aao.month(k)=imon;
     aao.index(k)=data(i,imon+1);
   end
end
  