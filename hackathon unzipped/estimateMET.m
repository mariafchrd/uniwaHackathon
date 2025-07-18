function met = estimateMET(speedKmh, elevationGainM, durationMin)
    % Convert to rate of elevation gain per minute
    elevationRate = elevationGainM / durationMin;
    
    % Adjust MET based on speed and climbing rate
    if speedKmh < 3
        baseMet = 3.5;
    elseif speedKmh < 5
        baseMet = 5.0;
    else
        baseMet = 6.0;
    end
    
    % Increase MET for steeper climbs
    if elevationRate > 5
        met = baseMet + 1.0;
    elseif elevationRate > 10
        met = baseMet + 2.0;
    else
        met = baseMet;
    end
end