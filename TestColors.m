% --------- Read instructions JSON archive -----------
json = readstruct("data/TestColors.json");

% Define color mappings
colorMap = containers.Map;
colorMap("white") = [1 1 1];
colorMap("grayLight") = [0.8706 0.8706 0.8706];
colorMap("gray") = [0.71 0.71 0.71];
colorMap("grayDark1") = [0.5 0.5 0.5];
colorMap("grayDark2") = [0.4000 0.3647 0.3647];
colorMap("black") = [0 0 0];
colorMap("yellow") = [0.9686 0.9294 0.3686];
colorMap("yellowDark") = [0.7882 0.6902 0.0549];
colorMap("purpleLight2") = [0.9216 0.7098 1.0000];
colorMap("purpleLight1") = [0.8745 0.4235 0.9020];
colorMap("purple") = [0.8078 0.3686 0.9686];
colorMap("purpleDark1") = [0.6902 0.1098 0.9020];
colorMap("purpleDark2") = [0.4196 0.0392 0.4392];


% Inicializar matriz vacía para los colores
testColors = [];

% Lista de nombres de grupo posibles
groupNames = ["Group1", "Group2", "Group3"];

for i = 1:length(groupNames)
    groupName = groupNames(i);
    if isfield(json.graphSpecifications, groupName)
        fillColor = json.graphSpecifications.(groupName).fillColor;
        if isKey(colorMap, fillColor)
            testColors(end+1, :) = colorMap(fillColor);  % añadir fila RGB
        else
            warning("Color '%s' no está definido en el mapa de colores.", fillColor);
        end
    else
        % Grupo no presente, continuar sin error
        fprintf("Grupo %s no encontrado en JSON. Ignorado.\n", groupName);
    end
end

%%
testColors = [
    1 1 1;                  %white
    0.8706 0.8706 0.8706;   %grayLight
    0.71 0.71 0.71;         %gray
    0.5 0.5 0.5;            %grayDark1
    0.4000 0.3647 0.3647;   %grayDark2
    0 0 0;                  %black
    0.9686 0.9294 0.3686;   %yellow
    0.7882 0.6902 0.0549;   %yellowDark
    0.9216 0.7098 1.0000;   %purpleLight2
    0.8745 0.4235 0.9020;   %purpleLight1
    0.8078 0.3686 0.9686;   %purple
    0.6902 0.1098 0.9020;   %purpleDark1
    0.4196 0.0392 0.4392    %purpleDark2
];

colorNames = ["white", "grayLight", "gray","grayDark1","grayDark2", "black",...
    "yellow", "yellowDark",...
    "purpleLight2", "purpleLight1", "purple", "purpleDark1", "purpleDark2"];  % nombres asociados a cada color


n = size(testColors, 1);

figure;
hold on;

for i = 1:n
    % Dibujar cada bloque de color
    rectangle('Position', [i, 0, 1, 1], 'FaceColor', testColors(i,:), 'EdgeColor', 'none');
    
    % Escribir nombre rotado 45°
    text(i + 0.5, -0.1, colorNames(i), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'top', ...
        'Rotation', 45, ...
        'FontSize', 10);
end

xlim([1 n+1]);
ylim([-0.5 1]);
axis off;
title('Colores RGB con nombres');