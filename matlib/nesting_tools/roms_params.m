
function roms_params(gname,grd_nb)

global IPRINT; IPRINT=0;
%grd_nb=3;
%gname='sd_grid.nc';
grd_pos1=nc_read([gname,'.1'],'grd_pos');
grd_pos2=nc_read([gname,'.2'],'grd_pos');
%grd_pos3=nc_read([gname,'.3'],'grd_pos');
refine_coef=nc_read([gname,'.2'],'refine_coef')

GRD_POS1=grd_pos1;
GRD_POS2(1)=(grd_pos1(1)-1)*refine_coef+grd_pos2(1);
GRD_POS2(2)=(grd_pos1(1)-1)*refine_coef+grd_pos2(2);
GRD_POS2(3)=(grd_pos1(3)-1)*refine_coef+grd_pos2(3);
GRD_POS2(4)=(grd_pos1(3)-1)*refine_coef+grd_pos2(4);
if grd_nb==3,
GRD_POS3(1)=(GRD_POS2(1)-1)*refine_coef+grd_pos3(1);
GRD_POS3(2)=(GRD_POS2(1)-1)*refine_coef+grd_pos3(2);
GRD_POS3(3)=(GRD_POS2(3)-1)*refine_coef+grd_pos3(3);
GRD_POS3(4)=(GRD_POS2(3)-1)*refine_coef+grd_pos3(4);
end;

disp(GRD_POS1')
disp(GRD_POS2)
disp(GRD_POS3)

