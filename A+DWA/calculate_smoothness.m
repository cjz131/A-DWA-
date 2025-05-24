% 辅助函数: 计算数据序列的平滑性（使用方差的倒数）
function smoothness = calculate_smoothness(data)
    if length(data) < 2
        smoothness = 0;
        return;
    end
    
    % 计算方差
    variance = var(data);
    
    % 平滑性定义为方差的倒数（加一个小常数避免除以零）
    smoothness = 1 / (variance + 1e-6);
end