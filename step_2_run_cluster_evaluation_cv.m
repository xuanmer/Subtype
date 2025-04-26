% for pca_rate = [0.80,0.85,0.90,0.95]
pathSaveFolder = '../ResultsCluster';
for pca_rate = 1.00
    rng(100)
    
    source = 'XUANWU';
    
    % 选择满足条件的行
    typedis = 'SCD';
    data = readtable(['../baseline/', ...
        typedis, '_ba_pad_b.csv'], NumHeaderLines=0);
    % selectedRows = data(strcmp(data.diagnosis, typedis), :);

    % 获取以 'Corrected_PAD' 结尾的列名
    colNames = data.Properties.VariableNames;
    selectedCols = colNames(endsWith(colNames, 'Corrected_PAD'));
    
    % 选择这些列
    selectedData = data(:, selectedCols);

    % % 选择以 'network' 开头的列
    % colNames = data.Properties.VariableNames;
    % networkCols = colNames(startsWith(colNames, 'network'));

    % % 创建包含所选列的新表
    % selectedData = selectedRows(:, networkCols);

    % 使用归一化
    % Feature = normalize(Feature);
    
    % 使用绝对值
    % Feature = abs(Feature);
    
    % cluster_num = 4;    %簇的数量
    % cv_num = 10;        %交叉验证的折数
    for_num = 100;      %循环的次数
    
    % SI的公式，越大越好，越接近 1 越好
    % https://www.mathworks.com/help/stats/clustering.evaluation.silhouetteevaluation.html#bt05vel
    
    min_cluster_num = intmax;
    min_eva_DB = intmax;
    max_eva_CH = intmin;
    max_eva_SI = intmin;
    % min_eva_gap = intmax;
    fprintf('pca_rate, cluster_num, eva_ess, eva_DB, eva_CH, eva_SI\n');
    for cluster_num = 2:10
        fileName = [pathSaveFolder, '/', source, '_', typedis, '_',...
            num2str(cluster_num), '_IDX', '.csv'];
        [eva_ess, eva_DB, eva_CH, eva_SI] = ...
            def_cluster_evaluation_for_no_fold(...
            selectedData, cluster_num, for_num, pca_rate, source, typedis, pathSaveFolder);
        fprintf('%.2f,%d,%.3f,%.3f,%.3f,%.3f\n', ...
            pca_rate, cluster_num, eva_ess, eva_DB, eva_CH, eva_SI);
        if(max_eva_CH < eva_CH) && (max_eva_SI < eva_SI)
            min_cluster_num = cluster_num;
            min_eva_ess = eva_ess;
            max_eva_CH = eva_CH;
            max_eva_SI = eva_SI;
            % min_eva_gap = eva_gap;
        end
    end
    fprintf("min_cluster_num: %d\n", min_cluster_num);
end