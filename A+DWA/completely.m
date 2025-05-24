% 读取和处理数据
traditionalData = readAndProcessData('实验结果1input.xlsx', '传统A*+DWA');
improvedData = readAndProcessData('实验结果input.xlsx', '改进A*+DWA');

% 计算评价指标
traditionalMetrics = calculateMetrics(traditionalData);
improvedMetrics = calculateMetrics(improvedData);

% 输出对比结果
printMetricsComparison(traditionalMetrics, improvedMetrics);

% 可视化对比（仅保留三项指标）
visualizeKeyMetrics(traditionalMetrics, improvedMetrics);

% 数据读取和预处理函数
function data = readAndProcessData(filename, algorithmName)
    % 读取数据
    data = readtable(filename);
    
    % 检查缺失值
    if any(isnan(data{:,:}))
        warning(['%s数据中存在缺失值', algorithmName]);
    end
    
    % 检查异常值（路径长度超过1000的视为异常）
    data = data(data.long < 1000, :);
    
    fprintf('%s数据处理完成，有效样本数: %d\n', algorithmName, height(data));
end

% 计算评价指标函数
function metrics = calculateMetrics(data)
    % 提取成功的样本
    successData = data(data.success == 1, :);
    
    % 计算各项指标
    metrics.successRate = sum(data.success) / height(data);
    metrics.avgTurningAngle = mean(abs(successData.angle));
    
    % 计算循迹速度
    metrics.trackingSpeed = successData.long ./ successData.time;
    metrics.avgTrackingSpeed = mean(metrics.trackingSpeed);
    metrics.stdTrackingSpeed = std(metrics.trackingSpeed);
end

% 输出指标对比结果
function printMetricsComparison(traditional, improved)
    fprintf('\n============= 性能对比分析 ============\n');
    fprintf('成功率: 传统A*+DWA = %.2f%%, 改进A*+DWA = %.2f%%\n', ...
        traditional.successRate*100, improved.successRate*100);
    fprintf('平均转折度数: 传统A*+DWA = %.2f°, 改进A*+DWA = %.2f°\n', ...
        traditional.avgTurningAngle, improved.avgTurningAngle);
    fprintf('循迹速度: 传统A*+DWA = %.4f 单位/秒 (±%.4f), 改进A*+DWA = %.4f 单位/秒 (±%.4f)\n', ...
        traditional.avgTrackingSpeed, traditional.stdTrackingSpeed, ...
        improved.avgTrackingSpeed, improved.stdTrackingSpeed);
    
    % 对比分析
    printComparisonResult('成功率', traditional.successRate, improved.successRate, true);
    printComparisonResult('平均转折度数', traditional.avgTurningAngle, improved.avgTurningAngle, false);
    printComparisonResult('循迹速度', traditional.avgTrackingSpeed, improved.avgTrackingSpeed, true);
end

% 辅助函数：打印单项对比结果
function printComparisonResult(metricName, traditionalValue, improvedValue, higherIsBetter)
    if (higherIsBetter && improvedValue > traditionalValue) || (~higherIsBetter && improvedValue < traditionalValue)
        fprintf('改进A*+DWA的%s更优\n', metricName);
    else
        fprintf('传统A*+DWA的%s更优\n', metricName);
    end
end

% 可视化关键指标对比（带数值标注）
function visualizeKeyMetrics(traditional, improved)
    figure('Position', [100, 100, 1200, 400]);
    
    % 定义指标数据
    successRates = [traditional.successRate, improved.successRate];
    turningAngles = [traditional.avgTurningAngle, improved.avgTurningAngle];
    trackingSpeeds = [traditional.avgTrackingSpeed, improved.avgTrackingSpeed];
    speedStds = [traditional.stdTrackingSpeed, improved.stdTrackingSpeed];
    labels = {'传统A*+DWA', '改进A*+DWA'};
    
    % 子图1：成功率对比
    subplot(1, 3, 1);
    bars = bar(successRates, 0.6, 'FaceColor', [0.2, 0.6, 0.8]);
    title('成功率对比');
    xlabel('算法');
    ylabel('成功率');
    set(gca, 'XTick', 1:2, 'XTickLabel', labels, 'YGrid', 'on');
    ylim([0, 1.1]);
    
    % 在柱状图上方添加数值标注（百分比格式）
    for i = 1:2
        text(bars.XData(i), bars.YData(i), sprintf('%.1f%%', successRates(i)*100), ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    
    % 子图2：平均转折度数对比
    subplot(1, 3, 2);
    bars = bar(turningAngles, 0.6, 'FaceColor', [0.9, 0.6, 0.1]);
    title('平均转折度数对比');
    xlabel('算法');
    ylabel('转折度数 (°)');
    set(gca, 'XTick', 1:2, 'XTickLabel', labels, 'YGrid', 'on');
    
    % 在柱状图上方添加数值标注
    for i = 1:2
        text(bars.XData(i), bars.YData(i), sprintf('%.1f°', turningAngles(i)), ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    
    % 子图3：循迹速度对比
    subplot(1, 3, 3);
    bars = bar(trackingSpeeds, 0.6, 'FaceColor', [0.8, 0.2, 0.2]);
    hold on;
    errorbar(1:2, trackingSpeeds, speedStds, 'k--', 'LineWidth', 1, 'CapSize', 5); % 优化误差线样式
    title('循迹速度对比');
    xlabel('算法');
    ylabel('平均速度 (单位/秒)');
    set(gca, 'XTick', 1:2, 'XTickLabel', labels, 'YGrid', 'on');
    legend('平均速度', '标准差', 'Location', 'best');
    
    % 在柱状图上方添加数值标注（带标准差）
    for i = 1:2
        text(bars.XData(i), bars.YData(i), ...
             sprintf('%.3f\n(±%.3f)', trackingSpeeds(i), speedStds(i)), ...
             'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end
    
    sgtitle('算法核心性能指标对比', 'FontSize', 14, 'FontWeight', 'bold');
    hold off;
end