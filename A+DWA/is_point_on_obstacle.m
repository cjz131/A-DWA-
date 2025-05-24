% 辅助函数: 检查点是否在障碍物上
function is_on_obs = is_point_on_obstacle(x, y, obstacles)
    is_on_obs = false;
    if isempty(obstacles)
        return;
    end
    
    for i = 1:size(obstacles, 1)
        if obstacles(i,1) == x && obstacles(i,2) == y
            is_on_obs = true;
            return;
        end
    end
end