function matrixOut = smooth2(matrixIn,dn)



[I,J]=size(matrixIn);
matrixOut=matrixIn*0;
for i=1:I
for j=1:J
   ii=i-dn:i+dn;
   jj=j-dn:j+dn;
   g=find(ii>=1 & ii<=I);
   ii=ii(g);
   g=find(jj>=1 & jj<=J);
   jj=jj(g);
   l=matrixIn(ii,jj);
   l=l(:);
   l=meanNaN(l,1);
   matrixOut(i,j)=l;
end
end
return   

