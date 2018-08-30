function [ percent_error ] = percentError( estimated, actual)
%[ percent_error ] = percentError( estimated, actual)
%   Returns the percent error

percent_error = (estimated - actual) ./ actual * 100;


end

