function evaluate_path_planning_performance(data_file)
    % 路径规划算法评价模型（路径-时间关系导向）
    % 输入: 实验数据Excel文件路径
    % 输出: 路径与时间关联分析结果
    
    % 读取实验数据
    try
        data = readtable(data_file);
        fprintf('成功读取实验数据: %s\n', data_file);
    catch
        error('无法读取数据文件，请检查文件路径和格式。');
    end
    
    % 计算总实验次数
    total_trials = height(data);
    
    % 提取数据列（假设列名已正确映射）
    start_x = table2array(data(:, 'start_X'));
    start_y = table2array(data(:, 'start_Y'));
    goal_x = table2array(data(:, 'de_X'));
    goal_y = table2array(data(:, 'de_Y'));
    path_length = table2array(data(:, 'long'));
    execution_time = table2array(data(:, 'time'));
    success = table2array(data(:, 'success'));
    success(isnan(success)) = 0; % 处理NaN
    
    % 计算欧式距离与理论最短时间
    euclidean_distance = sqrt((goal_x - start_x).^2 + (goal_y - start_y).^2);
    max_velocity = 0.06; % 自定义最大速度（m/s）
    theoretical_min_time = euclidean_distance / max_velocity;
    
    % 路径效率比（PER）与时间效率比（TER）
    path_efficiency_ratio = path_length ./ euclidean_distance; % PER = 路径长度/欧氏距离
    time_efficiency_ratio = execution_time ./ theoretical_min_time; % TER = 实际时间/理论时间
    
    % 仅分析成功案例
    valid_mask = success == 1;
    valid_per = path_efficiency_ratio(valid_mask);
    valid_ter = time_efficiency_ratio(valid_mask);
    valid_ed = euclidean_distance(valid_mask);
    valid_time = execution_time(valid_mask);
    
    % 基础统计量
    success_rate = sum(success)/total_trials * 100;
    avg_per = mean(valid_per);
    avg_ter = mean(valid_ter);
    std_per = std(valid_per);
    std_ter = std(valid_ter);
    
    % 路径-时间关系分析
    [rho_per_ter, p_per_ter] = corrcoef(valid_per, valid_ter); % 相关系数
    slope_time_ed = polyfit(valid_ed, valid_time, 1); % 时间-距离线性拟合
    
    % 输出结果
    fprintf('\n===== 路径与时间关系评价结果 =====\n');
    fprintf('总实验次数: %d\n', total_trials);
    fprintf('成功率: %.2f%%\n', success_rate);
    fprintf('\n路径效率统计（成功案例）:\n');
    fprintf('平均PER: %.2f ± %.2f\n', avg_per, std_per);
    fprintf('时间效率统计（成功案例）:\n');
    fprintf('平均TER: %.2f ± %.2f\n', avg_ter, std_ter);
    fprintf('\n路径-时间相关性:\n');
    fprintf('PER与TER相关系数: %.2f (p=%.4f)\n', rho_per_ter(1,2), p_per_ter(1,2));
    fprintf('时间-距离拟合方程: 时间 = %.4f * 距离 + %.4f (R²=%.2f)\n', ...
            slope_time_ed(1), slope_time_ed(2), polyfit(valid_ed, valid_time, 1, 'RSquare'));
    fprintf('===============================\n');
    
    % 可视化分析
    figure('Position', [100, 100, 1200, 600]);
    
    % 子图1：PER与TER散点图
    subplot(1, 2, 1);
    scatter(valid_per, valid_ter, 30, valid_ed, 'filled');
    colorbar;
    xlabel('路径效率比 (PER)');
    ylabel('时间效率比 (TER)');
    title('PER与TER相关性分析');
    text(0.1, max(valid_ter)*0.9, ...
         sprintf('相关系数: %.2f\np值: %.4f', rho_per_ter(1,2), p_per_ter(1,2)), ...
         'FontSize', 10, 'BackgroundColor', 'white');
    
    % 子图2：时间-距离拟合曲线
    subplot(1, 2, 2);
    scatter(valid_ed, valid_time, 30, valid_per, 'filled');
    hold on;
    f = fit(valid_ed', valid_time', 'poly1');
    plot(f, 'r-', 'LineWidth', 1.5);
    hold off;
    colorbar;
    xlabel('欧式距离 (m)');
    ylabel('执行时间 (s)');
    title('执行时间与欧式距离关系');
    text(min(valid_ed)*1.1, max(valid_time)*0.9, ...
         sprintf('拟合方程: y = %.4f x + %.4f', f.p1, f.p2), ...
         'FontSize', 10, 'BackgroundColor', 'white');
    
    % 保存结果到Excel（仅关键指标）
    results_table = table(euclidean_distance, path_length, execution_time, ...
                          path_efficiency_ratio, time_efficiency_ratio, success, ...
                          'VariableNames', {'欧式距离', '路径长度', '执行时间', ...
                                           'PER', 'TER', '是否成功'});
    
    [file_path, file_name, ~] = fileparts(data_file);
    output_file = fullfile(file_path, [file_name, '_路径时间分析.xlsx']);
    writetable(results_table, output_file);
    fprintf('分析结果已保存至: %s\n', output_file);
end