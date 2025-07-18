% clc
clear
close all;

% TRAINING
load('ExampleData.mat');
load ActivityLogs
head(sitAcceleration)
sitLabel='sitting';
sitLabel=repmat(sitLabel,size(sitAcceleration,1),1);
sitAccelaration.Activity=sitLabel;
head(walkAcceleration)
walkLabel='walking';
walkLabel=repmat(walkLabel,size(walkAcceleration,1),1);
walkAccelaration.Activity=walkLabel;
head(runAcceleration)
runLabel='running';
runLabel=repmat(runLabel,size(runAcceleration,1),1);
runAccelaration.Activity=runLabel;
allAcceleration = [sitAcceleration; walkAcceleration;runAcceleration];
allAcceleration = timetable2table(allAcceleration,"ConvertRowTimes", false);
allAcceleration.Categories=[sitLabel;walkLabel;runLabel];

justAcc = timetable2table(unknownAcceleration, "ConvertRowTimes",false);
%save("TRAINEDMODEL.mat","TRAINEDMODEL")
load('TRAINEDMODEL.mat');
yfit = TRAINEDMODEL.predictFcn(justAcc);


%COMPUTING CHARACTERISTICS OF MOVEMENT
load('ExampleData.mat');
lat=Position.latitude;
lon=Position.longitude;
alt=Position.altitude;
speedKmh=Position.speed;
TimeStamp=Position.Timestamp;
Xacc = Acceleration.X;
Yacc = Acceleration.Y;
Zacc = Acceleration.Z;
accelDatetime=Acceleration.Timestamp;


weight= 68;
height=168;

startTime = Acceleration.Timestamp(1);
endTime = Acceleration.Timestamp(end);

% Calculate the total duration in seconds
durationSec = seconds(endTime - startTime);

elevationGain = computeElevationGain(alt);
met = estimateMET(speedKmh, alt, durationSec);


% We use the following to obtain linear time data in seconds from a datetime array
positionTime=timeElapsed(TimeStamp);
accelTime=timeElapsed(accelDatetime);
earthCirc = 24901;
totaldis = 0;

for i = 1:(length(lat)-1)
lat1 = lat(i); % The first latitude
lat2 = lat(i+1); % The second latitude
lon1 = lon(i); % The first longitude
lon2 = lon(i+1); % The second longitude
degDis = distance(lat1, lon1, lat2, lon2);
dis = (degDis/360)*earthCirc;
totaldis = totaldis + dis;
end

stride = 2.5; % Average stride (ft)
totaldis_ft = totaldis*5280; % Converting distance from miles to feet
steps = totaldis_ft/stride;

caloriesBurned=round(met*weight*durationSec/(60*60));


%PLOTS
figure;
yfitcat = categorical(cellstr(yfit));
pie(yfitcat)
title("Overall Activity Profile");


figure;
geoplot(lat, lon, '-o');
geobasemap topographic
title('Hiking Path');

% Plot elevation vs time
figure;
plot(positionTime, alt, '-');
xlabel('Time');
ylabel('Altitude (m)');
title('Elevation Profile');

% Plot speed vs time
figure;
plot(positionTime, speedKmh, '-');
xlabel('Time');
ylabel('Speed (m/s)');
title('Speed over Time');
