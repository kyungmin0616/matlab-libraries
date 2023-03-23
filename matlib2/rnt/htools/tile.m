function [Istr,Iend,Jstr,Jend]=tile(Lm,Mm,NtileX,NtileE,tile);
      
ChunkSizeX=floor((Lm+NtileX-1)./NtileX);
ChunkSizeE=floor((Mm+NtileE-1)./NtileE);
MarginX=floor((NtileX.*ChunkSizeX-Lm)./2);
MarginE=floor((NtileE.*ChunkSizeE-Mm)./2);

jtile=floor(tile./NtileX);
itile=tile-jtile.*NtileX;

Istr=1+itile.*ChunkSizeX-MarginX;
Iend=Istr+ChunkSizeX-1;
Istr=max(Istr,1);
Iend=min(Iend,Lm);

Jstr=1+jtile.*ChunkSizeE-MarginE;
Jend=Jstr+ChunkSizeE-1;
Jstr=max(Jstr,1);
Jend=min(Jend,Mm);

disp(' ');
for i=1:length(tile),
  disp([' tile: ',  num2str(tile(i),'%2.2i'), '  ', ...
	' Itile = ', num2str(itile(i),'%2.2i'), ...
        ' Jtile = ', num2str(jtile(i),'%2.2i'), ...
	' Istr = ', num2str(Istr(i),'%3.3i'), ...
        ' Iend = ', num2str(Iend(i),'%3.3i'), ...
        ' Jstr = ', num2str(Jstr(i),'%3.3i'), ...
        ' Jend = ', num2str(Jend(i),'%3.3i')]);
end,
disp(' ');

return