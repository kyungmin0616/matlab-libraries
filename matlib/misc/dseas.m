function sig1=dseas(sig,months)

for imon=1:12
  in=find(months == imon);
  sigm(imon)=meanNaN(sig(in),1);
end

for i=1:length(sig)
   imon = months(i);
   sig1(i) = sig(i) - sigm(imon);
end     
