% 1. 全局路径规划调用
[Line_path, distance_x, OPEN_num] = Astar_G_du(Obs_Closed, Start, Goal, MAX_X, MAX_Y);

% 2. 动态障碍物路径预规划
[Obst_d_path, ~, ~] = Astar_G_du(Obs_Closed, Obst_d_d_St, Obst_d_d_Ta, MAX_X, MAX_Y);
Obst_d_d_line = Line_obst(Obst_d_path_X, L_obst); % 生成动态障碍物轨迹

% 3. 局部避障主循环
Result_x = DWA_ct_dong(Obs_Closed, Obst_d_d_line, Obs_d_j, Area_MAX, Goal, Line_path, path_node, Start, angle_node, Kinematic, evalParam);

% 4. 结果可视化
plot(Result_x(:,1)+0.5, Result_x(:,2)+0.5, 'b', 'linewidth', 2); % 绘制机器人轨迹