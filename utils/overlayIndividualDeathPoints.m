function overlayIndividualDeathPoints(data, group, group_categories, ...
                                     graphBar, nGroup, nRegions, ...
                                     lineColorMatrix, jsonFilePath, deathVector)
% overlayIndividualDeathPoints - Overlays individual data points on bar graph,
% coloring those with death == "si" differently.
%
% INPUTS:
%   data             - Numeric matrix of subject-level data (rows: subjects, columns: regions)
%   group            - Categorical or cell array specifying group assignment per subject
%   group_categories - Cell array with unique group names (must match order in plotting)
%   graphBar         - Bar graph object returned by bar()
%   nGroup           - Number of groups
%   nRegions         - Number of regions (columns in 'data')
%   lineColorMatrix  - nGroup x 3 matrix of RGB colors for marker edges/fills
%   jsonFilePath     - Path to JSON file with 'markerShape' and 'fillStatus' info
%   deathVector      - Logical vector (numSubjects x 1), true if death == "si", else false

% Read marker shape and fill info
[markerShapeMatrix, filledStatusLogical] = generateIndividualMarkers(jsonFilePath);

% Overlay points for each group and region
for g = 1:nGroup
    % Extract indices and data for group g
    isInGroup = group == group_categories{g};
    data_group = data(isInGroup, :);
    death_group = deathVector(isInGroup);

    % For each region (column)
    for r = 1:nRegions
        xPos = graphBar(g).XEndPoints(r);
        yVals = data_group(:, r);
        marker = markerShapeMatrix{g};

        % Split points by death status
        idxDeath = death_group;       % Subjects with death == "si"
        idxNoDeath = ~death_group;    % Subjects with death == "no"

        % Plot points with death == "si" in red
        if any(idxDeath)
            scatter(repmat(xPos, sum(idxDeath), 1), yVals(idxDeath), 30, ...
                'Marker', marker, ...
                'MarkerEdgeColor', [1 0 0], ...        % rojo
                'MarkerFaceColor', [1 0 0], ...
                'LineWidth', 1, ...
                'jitter', 'on', 'jitterAmount', 0.10);
            hold on;
        end

        % Plot points with death == "no" in original group color
        if any(idxNoDeath)
            if filledStatusLogical(g)
                scatter(repmat(xPos, sum(idxNoDeath), 1), yVals(idxNoDeath), 30, ...
                    'Marker', marker, ...
                    'MarkerEdgeColor', lineColorMatrix(g,:), ...
                    'MarkerFaceColor', lineColorMatrix(g,:), ...
                    'LineWidth', 1, ...
                    'jitter', 'on', 'jitterAmount', 0.10);
            else
                scatter(repmat(xPos, sum(idxNoDeath), 1), yVals(idxNoDeath), 30, ...
                    'Marker', marker, ...
                    'MarkerEdgeColor', lineColorMatrix(g,:), ...
                    'MarkerFaceColor', 'none', ...
                    'LineWidth', 1, ...
                    'jitter', 'on', 'jitterAmount', 0.10);
            end
            hold on;
        end
    end
end
hold off
end