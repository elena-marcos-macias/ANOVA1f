function [fillColorMatrix, lineColorMatrix, figHandle] = generateColorMatrices(jsonFilePath)
    % Read the JSON file
    json = readstruct(jsonFilePath);

    % Define the color map
    colorMap = containers.Map;
    colorMap("white") = [1 1 1];
    colorMap("grayLight") = [0.8706 0.8706 0.8706];
    colorMap("gray") = [0.71 0.71 0.71];
    colorMap("grayDark1") = [0.5 0.5 0.5];
    colorMap("grayDark2") = [0.4000 0.3647 0.3647];
    colorMap("black") = [0 0 0];
    colorMap("yellowLight2") = [0.9882 0.9882 0.5922];
    colorMap("yellowLight1") = [0.9686 0.9294 0.3686];
    colorMap("yellow") = [1.0000 0.9490 0.2196];
    colorMap("yellowDark1") = [0.8784 0.8392 0.2549];
    colorMap("yellowDark2") = [0.7882 0.6902 0.0549];
    colorMap("purpleLight2") = [0.9216 0.7098 1.0000];
    colorMap("purpleLight1") = [0.8745 0.4235 0.9020];
    colorMap("purple") = [0.8078 0.3686 0.9686];
    colorMap("purpleDark1") = [0.6902 0.1098 0.9020];
    colorMap("purpleDark2") = [0.4196 0.0392 0.4392];
    colorMap("blueLight2") = [0.8000 0.9294 0.9059];
    colorMap("blueLight1") = [0.6314 0.9412 0.8824];
    colorMap("blue") = [0.3569 0.9412 0.8314];
    colorMap("blueDark1") = [0.1059 0.8196 0.6902];
    colorMap("blueDark2") = [0.0549 0.6706 0.5569];

    % List of possible group names
    groupNames = ["Group1", "Group2", "Group3", "Group4", "Group5", "Group6", "Group7", "Group8"];

    % Initialize fill color matrix
    fillColorMatrix = [];
    lineColorMatrix = [];

    for i = 1:length(groupNames)
        groupName = groupNames(i);
        if isfield(json.graphSpecifications, groupName)
            fillColor = json.graphSpecifications.(groupName).fillColor;
            if isKey(colorMap, fillColor)
                fillColorMatrix(end+1, :) = colorMap(fillColor); % append RGB row
            else
                warning("Color '%s' is not defined in the color map.", fillColor);
            end
        else
            fprintf("Group %s not found in JSON. Ignored.\n", groupName);
        end
    end

    for i = 1:length(groupNames)
        groupName = groupNames(i);
        if isfield(json.graphSpecifications, groupName)
            lineColor = json.graphSpecifications.(groupName).lineColor;
            if isKey(colorMap, lineColor)
                lineColorMatrix(end+1, :) = colorMap(lineColor); % append RGB row
            else
                warning("Color '%s' is not defined in the color map.", lineColor);
            end
        else
            fprintf("Group %s not found in JSON. Ignored.\n", groupName);
        end
    end

    % Explicit definition of colors and names (manual order)
    ColorMatrix = [
        1 1 1;                  % white
        0.8706 0.8706 0.8706;   % grayLight
        0.71 0.71 0.71;         % gray
        0.5 0.5 0.5;            % grayDark1
        0.4000 0.3647 0.3647;   % grayDark2
        0 0 0;                  % black
        0.9882 0.9882 0.5922;   % yellowLight2
        0.9686 0.9294 0.3686;   % yellowLight1
        1.0000 0.9490 0.2196;   % yellow
        0.8784 0.8392 0.2549;   % yellowDark1
        0.7882 0.6902 0.0549;   % yellowDark2
        0.9216 0.7098 1.0000;   % purpleLight2
        0.8745 0.4235 0.9020;   % purpleLight1
        0.8078 0.3686 0.9686;   % purple
        0.6902 0.1098 0.9020;   % purpleDark1
        0.4196 0.0392 0.4392;   % purpleDark2
        0.8000 0.9294 0.9059;   % blueLight2
        0.6314 0.9412 0.8824;   % blueLight1
        0.3569 0.9412 0.8314;   % blue
        0.1059 0.8196 0.6902;   % blueDark1
        0.0549 0.6706 0.5569    % blueDark2
    ];

    colorNames = ["white", "grayLight", "gray", "grayDark1", "grayDark2", "black", ...
                  "yellowLight2", "yellowLight1", "yellow", "yellowDark1", "yellowDark2", ...
                  "purpleLight2", "purpleLight1", "purple", "purpleDark1", "purpleDark2", ...
                  "blueLight2", "blueLight1", "blue", "blueDark1", "blueDark2"];

    % Create the figure showing color names and RGB
    n = size(ColorMatrix, 1);
    figHandle = figure;
    hold on;

    for i = 1:n
        % Draw each color block
        rectangle('Position', [i, 0, 1, 1], 'FaceColor', ColorMatrix(i,:), 'EdgeColor', 'none');

        % Display the color name rotated 45°
        text(i + 0.5, -0.1, colorNames(i), ...
            'HorizontalAlignment', 'center', ...
            'VerticalAlignment', 'top', ...
            'Rotation', 45, ...
            'FontSize', 10);
    end

    xlim([1 n+1]);
    ylim([-0.5 1]);
    axis off;
    title('RGB Colors with Names');
end