function elevationGain = computeElevationGain(altitude)
    % altitude: vector of altitude readings in meters
    delta = diff(altitude);
    elevationGain = sum(delta(delta > 0));  % only count positive changes
end