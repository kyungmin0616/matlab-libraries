
function run_estimate(dt,sec_x_timestep)

year_sec = 360*24*60*60;

ntimesteps = year_sec/dt;

total_sec = ntimesteps * sec_x_timestep;

hours_x_year = total_sec/60/60

year_x_year = total_sec/24/60/60
