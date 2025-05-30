function [Group, Group_categories, nGroup] = getCategoricalGroup(T_Original, group_name)
%GETCATEGORICALGROUP Extrae una variable categórica de una tabla
%
% [Group, Group_categories, nGroup] = getCategoricalGroup(T_Original, group_name)
%
% Inputs:
%   - T_Original: tabla con los datos originales
%   - group_name: nombre (string o char) de la columna a usar como variable categórica
%
% Outputs:
%   - Group: variable categórica extraída de la tabla
%   - Group_categories: categorías únicas de la variable categórica
%   - nGroup: número de categorías

    % Verifica que el nombre exista en la tabla
    col_index = find(strcmp(T_Original.Properties.VariableNames, group_name));
    
    if isempty(col_index)
        error('No se encontró la columna con el nombre "%s" en la tabla.', group_name);
    end
    
    % Extrae la columna y conviértela en variable categórica
    Group = categorical(T_Original{:, col_index});
    Group_categories = categories(Group);
    nGroup = numel(Group_categories);
end