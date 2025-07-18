function elevationRate = computeElevationRate(altitude, timeSec)
    % timeSec: total duration in seconds
    gain = computeElevationGain(altitude);
    durationMin = timeSec / 60;
    elevationRate = gain / durationMin;  % meters per minute
end