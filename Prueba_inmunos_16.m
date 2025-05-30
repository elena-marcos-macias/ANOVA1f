% USE Statistical analysis for 1 factor inter-group (the code compares the
% different groups amongst eachother per variable, but does not compare
% across variables)
%
% INPUTS
%   - ArchiveName.xlsx      Excel archive in the same file where the program runs...
%                           each row must correspond to a subject,...
%                           there must be a categorical variable, e.g. "experimental group".
%
% OUTPUTS
%   - DescriptiveStatistics.xlsx        Excel archive containing Mean and Standard deviation per group and variable
%   - VarianceAnalysis.xlsx             Excel archive containing Statistics and p-value after the group comparisons per variable (ANOVA or Kruskal-Wallis)
%   - Posthoc_AllComparisons.xlsx       Excel archive containing p-value after the post hoc analysis for all possible comparisons (Tukey or Dunn-Bonferroni)
%   - Posthoc_vsControl1.xlsx           Excel archive containing p-value after the post hoc analysis for the comparisons against a control group (Dunnett or Dunn-Bonferroni)
%   - Posthoc_vsControl2.xlsx           (Optional) Excel archive equal to 'Posthoc_vsControl1' for a different control group (Dunnett or Dunn-Bonferroni)
%   - BarPlot                           Bar plot that represents the mean and SD for each group, grouped per variable. It also marks with an '*' those comparisons that have a p-value < 0.05.

% github; git; json

%--------- Add function path and set save path ----------
addpath ('./utils');
savePath = './results/';

% --------- Read instructions JSON archive -----------
json = readstruct("data/instructionsANOVA1f.json");

%--------- Load data ---------
fileName = char(json.inputDataSelection.fileName);
T_Original = readtable(['./data/' fileName]);

% -------- Remove rows with NaN --------
T_Original = rmmissing(T_Original);  % Remove rows that contain at least one NaN

% -------- Select data to use (columns with string or numerical criteria) ---------------
target_columns = int32(json.inputDataSelection.columnCriteria.target_columns); % funcionan solo cuando lo que introduzco en el json son integers
ignore_columns = int32(json.inputDataSelection.columnCriteria.ignore_columns); % funcionan solo cuando lo que introduzco en el json son integers
    % el comando int32 hay que meterlo dentro de la función
T_Data = selectColumns (T_Original, target_columns, ignore_columns);
regions_unique = T_Data.Properties.VariableNames;
nRegions = numel(regions_unique);

% ------- Define categorical variable ('Group') and its categories ----------
groupName = char(json.inputDataSelection.groupName);
[group, group_categories, nGroup] = getCategoricalGroup(T_Original, groupName);


% -------- Prepare numeric data (array format) for analysis ---------
data = table2array(T_Data);


%% DESCRIPTIVE ANALYSIS

% --------- Mean and standard deviation -----------------
[T_descriptives, mean_RegionGroup, sd_RegionGroup] = compute_descriptives(data, group, group_categories, regions_unique, nRegions, nGroup);
% Save results as .xlsx
writetable(T_descriptives, [savePath char(json.outputFileNames.descriptiveStatistics)]);


%% VARIANCE ANALYSIS - ANOVA 1F

% ------------ Check normality and homogeneity ---------------
ANOVA_friendly = checkANOVA1f(data, group, group_categories);

%------------- Analysis of variance (ANOVA or KRUSKAL-WALLIS)---------------
[T_VarianceAnalysis, p_variance] = variance1f_analysis(data, group, ANOVA_friendly, regions_unique);
% Save results as .xlsx
writetable(T_VarianceAnalysis, [savePath char(json.outputFileNames.varianceAnalysis)]);

% ------------- Post-hoc - All comparisons (Tukey or Dunn-Bonferroni) -------
T_posthoc_AllComparisons = posthoc1f_allcomparisons(data, group, group_categories, ANOVA_friendly, regions_unique);
% Save results as .xlsx
writetable(T_posthoc_AllComparisons, [savePath char(json.outputFileNames.posthoc_AllComparisons)]);

% ------------- Post-hoc - Comparisons against control (Dunnett or Dunn-Bonferroni vs. control) -------
controlGroup1 = char(json.inputDataSelection.groupControl.controlGroup1);
controlGroup2 = char(json.inputDataSelection.groupControl.controlGroup2);
[T_posthoc_vsControl1, T_posthoc_vsControl2] = posthoc1f_againstcontrol(data, group, regions_unique, ANOVA_friendly, nRegions, nGroup, controlGroup1, controlGroup2);
% Save results as .xlsx
writetable(T_posthoc_vsControl1,[savePath char(json.outputFileNames.posthoc_vsControl1)]);
writetable(T_posthoc_vsControl2,[savePath char(json.outputFileNames.posthoc_vsControl2)]);


%% --------------------- PLOT ----------------------------------
order = cellstr(string(json.inputDataSelection.groupOrder))';
group = reordercats(group, order); % Order in which groups should appear
group_categories = categories(group); % After reordering, refresh the group variable

% Colors. Use the command `uisetcolor` to explore color values
myColors = [...
    1 1 1;              % white
    0.71 0.71 0.71;     % gray
    0.9686 0.9294 0.3686; % yellow
    0.8745 0.4235 0.9020]; % purple
myColorsDark = [...
    0.5 0.5 0.5;        % dark gray 1
    0.4000 0.3647 0.3647; % dark gray 2
    0.7882 0.6902 0.0549; % dark yellow
    0.4196 0.0392 0.4392]; % dark purple

% Bar plot
graphBar = bar(mean_RegionGroup');
for g = 1:nGroup
    graphBar(g).FaceColor = myColors(g,:);
    graphBar(g).EdgeColor = myColorsDark(g,:);
    graphBar(g).BarWidth = 0.85;
    graphBar(g).LineWidth = 1.5;
end

% Error bars
hold on
for g = 1:nGroup
    x = graphBar(g).XEndPoints;
    y = graphBar(g).YData;
    e = sd_RegionGroup(g,:);
    errorbar(x, y, e, 'k.', 'LineWidth', 1);
end

% Overlay individual data points
nSubjects = size(data, 1);
colors = lines(nGroup);  % Color map by group
markerShapes = {'^', 'o', '^', 'o'};  % Marker shapes by group
filledStatus = [false, false, true, true]; % filled or not
for g = 1:nGroup
    % Extract individual data for group g
    data_gesima = data(group == group_categories{g}, :);
    % For each region (column)
    for r = 1:nRegions
        % X: the X position of the corresponding bar
        xPos = graphBar(g).XEndPoints(r);
        % Y: the individual values
        yVals = data_gesima(:, r);
        % Draw points
        marker = markerShapes{g};
        if filledStatus(g)
            scatter(repmat(xPos, size(yVals)), yVals, 30,...
                'Marker', marker,...
                'MarkerEdgeColor', myColorsDark(g,:), ...
                'MarkerFaceColor', myColorsDark(g,:),...
                'LineWidth', 1 , ...
                'jitter', 'on', 'jitterAmount', 0.10);
        else
            scatter(repmat(xPos, size(yVals)), yVals, 30,...
                'Marker', marker,...
                'MarkerEdgeColor', myColorsDark(g,:), ...
                'MarkerFaceColor', 'none',...
                'LineWidth', 1 , ...
                'jitter', 'on', 'jitterAmount', 0.10);
        end
    end
end

% Add asterisks where p < 0.05
for r = 1:nRegions
    if p_variance(r) < 0.01
        % Get max bar height in region r
        maxY = max(mean_RegionGroup(:, r) + sd_RegionGroup(:, r));
        % Centered X position for the asterisk
        xPos = mean(arrayfun(@(g) graphBar(g).XEndPoints(r), 1:nGroup));
        % Add asterisk
        text(xPos, maxY + 0.13 * maxY, '**', 'FontSize', 30, 'HorizontalAlignment', 'center', 'Color', 'k');
    elseif p_variance(r) < 0.05
        % Get max bar height in region r
        maxY = max(mean_RegionGroup(:, r) + sd_RegionGroup(:, r));
        % Centered X position for the asterisk
        xPos = mean(arrayfun(@(g) graphBar(g).XEndPoints(r), 1:nGroup));
        % Add asterisk
        text(xPos, maxY + 0.13 * maxY, '*', 'FontSize', 30, 'HorizontalAlignment', 'center', 'Color', 'k');
    end
end

% Add horizontal lines below asterisks where p < 0.05
for r = 1:nRegions
    if p_variance(r) < 0.05
        % X positions for the line ends (first and last group bar)
        xLeft = graphBar(1).XEndPoints(r);
        xRight = graphBar(end).XEndPoints(r);
        % Height (just below the asterisk)
        maxY = max(mean_RegionGroup(:, r) + sd_RegionGroup(:, r));
        yBar = maxY + 0.11 * maxY;
        % Draw horizontal line
        plot([xLeft, xRight], [yBar, yBar], 'k-', 'LineWidth', 1.5);
    end
end

% Add horizontal lines xxxxx
%for r = 1:nRegions
%    if p_variance(r) < 0.05
        % X positions for the line ends (first and last group bar)
%        xLeft = graphBar(1).XEndPoints(r);
%        xRight = graphBar(end).XEndPoints(r);
        % Height (just below the asterisk)
%        maxY = max(mean_RegionGroup(:, r) + sd_RegionGroup(:, r));
%        yBar = maxY + 0.11 * maxY;
        % Draw horizontal line
%        plot([xLeft, xRight], [yBar, yBar], 'k-', 'LineWidth', 1.5);
%    end
%end

% Labels and title
title(char(json.graphSpecifications.graphTitle));
legend(group_categories);
xticklabels(T_Data.Properties.VariableNames);
xticks(1:nRegions);
xlabel(char(json.graphSpecifications.xAxisLabel));
ylabel(char(json.graphSpecifications.yAxisLabel));
hold off