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
%   - BarPlot.fig                       Bar plot that represents the mean and SD for each group, grouped per variable. It also marks with an '*' those comparisons that have a p-value < 0.05.


%--------- Add function path and set save path ----------
addpath ('./utils');
addpath ('./requirements');
savePath = './results/';

% --------- Read instructions JSON archive -----------
json = readstruct("data/instructionsANOVA1f.json");

%--------- Load data ---------
fileName = char(json.inputDataSelection.fileName);
T_Original = readtable(['./data/' fileName]);

% -------- Remove rows with NaN --------
T_Original = rmmissing(T_Original);  % Remove rows that contain at least one NaN

% -------- Select data to use (columns with string or numerical criteria) ---------------
target_columns = json.inputDataSelection.columnCriteria.target_columns;
ignore_columns = json.inputDataSelection.columnCriteria.ignore_columns;
T_Data = selectColumns (T_Original, target_columns, ignore_columns);
regions_unique = T_Data.Properties.VariableNames;
nRegions = numel(regions_unique);

% ------- Define categorical variable ('Group') and its categories ----------
groupName = char(json.inputDataSelection.groupName);
[group, group_categories, nGroup] = getCategoricalGroup(T_Original, groupName);


% -------- Prepare numeric data (array format) for analysis ---------
data = table2array(T_Data);


%% DESCRIPTIVE ANALYSIS

order = cellstr(string(json.inputDataSelection.groupOrder))';
group = reordercats(group, order); % Order in which groups should appear
group_categories = categories(group); % After reordering, refresh the group variable

% --------- Mean and standard deviation -----------------
[T_descriptives, mean_RegionGroup, sd_RegionGroup] = compute_descriptives(data, group, group_categories, regions_unique, nRegions, nGroup);
% Save results as .xlsx
writetable(T_descriptives, [savePath char(json.outputFileNames.descriptiveStatistics)]);


%% VARIANCE ANALYSIS - ANOVA 1F

order = cellstr(string(json.inputDataSelection.groupOrder))';
group = reordercats(group, order); % Order in which groups should appear
group_categories = categories(group); % After reordering, refresh the group variable

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

% Choose the graph's colors 
[fillColorMatrix, lineColorMatrix] = generateColorMatrices("data/instructionsANOVA1f.json");

% Bar plot
graphBar = bar(mean_RegionGroup');
for g = 1:nGroup
    graphBar(g).FaceColor = fillColorMatrix(g,:);
    graphBar(g).EdgeColor = lineColorMatrix(g,:);
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

% Add asterisks where p < 0.05
addSignificanceMarkers(p_variance, mean_RegionGroup, sd_RegionGroup, graphBar);


% Overlay individual data points with or without death markers
if char(json.graphSpecifications.showHighlightVariable) == "yes"
    highlightVariable = char(json.graphSpecifications.highlightVariable);
    deathVector = strcmpi(T_Original.(highlightVariable), 'yes');  
    overlayIndividualDeathPoints(data, group, group_categories, ...
                                     graphBar, nGroup, nRegions, ...
                                     lineColorMatrix, "data/instructionsANOVA1f.json", deathVector);
else
    overlayIndividualDataPoints(data, group, group_categories, ...
                                     graphBar, nGroup, nRegions, ...
                                     lineColorMatrix, "data/instructionsANOVA1f.json");
end


% Labels and title
title(char(json.graphSpecifications.graphTitle));
legend(group_categories);
xticklabels(T_Data.Properties.VariableNames);
xticks(1:nRegions);
xlabel(char(json.graphSpecifications.xAxisLabel));
ylabel(char(json.graphSpecifications.yAxisLabel));
hold off

% Save results as .fig
savefig(fullfile(savePath, json.outputFileNames.graphBar));