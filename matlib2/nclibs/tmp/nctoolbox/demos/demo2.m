% DEMO2 - Subsetting data

echo('on')

%% ---- Open the dataset
ds = ncdataset('http://dods.mbari.org/cgi-bin/nph-nc/data/ssdsdata/deployments/m1/200810/OS_M1_20081008_TS.nc')

% You can view the variables available to you
ds.variables

%% Plot all the data
plot(ds.time('TIME'), ds.data('TEMP', [1 1 1 1], [max(ds.size('TEMP')) 1 1 1], [1 1 1 1]))
hold('on')

%% ---- Lets fetch a subset of time in Matlab's native format
startIdx = 100;
endIdx = max(ds.size('TIME'));
stride = 10
t = ds.data('TIME', startIdx, endIdx, stride);
t = ds.time('TIME', t); % Convert time data to matlab format. See help ncdataset.time

%% ---- Now lets get a subset of the temperature data.
% NOTE: The shape of the variables size is important for subsetting
ds.size('TEMP')
% Use variable, start, end, stride to subset
temp = ds.data('TEMP', [startIdx 1 1 1], [endIdx 1 1 1], [stride 1 1 1]);

%% ---- Plot it
plot(t, temp, 'r.')
datetick('x', 2);
grid
legend('All Data', 'Decimated Data')
echo('off')