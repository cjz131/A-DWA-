% 清空环境
clc
clear
rng('shuffle'); % 设置随机数种子，确保结果可重现

% 地图建模
MAX0= [     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0 
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 ] ;
MAX=rot90(MAX0,3);
MAX_X=size(MAX,2);
MAX_Y=size(MAX,1);

% 初始化障碍物列表
k=1;
CLOSED=[];
for j=1:MAX_X
    for i=1:MAX_Y
        if (MAX(i,j)==1)
            CLOSED(k,1)=i;
            CLOSED(k,2)=j;
            k=k+1;
        end
    end
end
Obs_Closed=CLOSED;
num_Closed=size(CLOSED,1);

% 设置实验参数
num_experiments = 100; % 实验次数
results = zeros(num_experiments, 8); % 存储实验结果 [起点x, 起点y, 目标x, 目标y, 路径长度, 转折度数, 执行时间, 成功率]

% 显示实验开始消息
h=msgbox(['开始进行 ', num2str(num_experiments), ' 次随机实验，请耐心等待...']);
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end

% 机器人参数设置
angle_node=pi/4;
Kinematic=[1.5,toRadian(20.0),0.2,toRadian(50.0),0.02,toRadian(1)];
evalParam=[0.05,0.2,0.3,3.0];

% 移动障碍物参数设置
L_obst=0.026; % 移动障碍物速度
timeout_threshold = 300; % 超时阈值（秒）

% 实验循环
for exp_idx = 1:num_experiments
    % 随机生成起点和目标点
    valid_points = false;
    max_attempts = 100;
    attempt = 0;
    
    while ~valid_points && attempt < max_attempts
        attempt = attempt + 1;
        
        % 随机生成起点和目标点
        xStart = randi([1, MAX_X]);
        yStart = randi([1, MAX_Y]);
        xTarget = randi([1, MAX_X]);
        yTarget = randi([1, MAX_Y]);
        
        % 检查起点和目标点是否在障碍物上
        if ~is_point_on_obstacle(xStart, yStart, Obs_Closed) && ...
           ~is_point_on_obstacle(xTarget, yTarget, Obs_Closed) && ...
           (xStart ~= xTarget || yStart ~= yTarget) % 确保起点和目标点不相同
           
            % 使用A*算法检查两点是否可达
            Start=[xStart yStart];
            Goal=[xTarget yTarget];
            [Line_path,~,~]=Astar_G(Obs_Closed,Start,Goal,MAX_X,MAX_Y);
            
            if ~isempty(Line_path) % 如果路径不为空，表示两点可达
                valid_points = true;
            end
        end
    end
    
    if ~valid_points
        % 如果无法找到有效的起点和目标点，跳过本次实验
        results(exp_idx, :) = [xStart, yStart, xTarget, yTarget, 0, 0, 0, 0];
        fprintf('实验 %d/%d: 无法找到有效的起点和目标点\n', exp_idx, num_experiments);
        continue;
    end
    
    % 保存起点和目标点
    results(exp_idx, 1:4) = [xStart, yStart, xTarget, yTarget];
    
    % 随机设置移动障碍物的起点和终点
    Obst_xS = randi([1, MAX_X]);
    Obst_yS = randi([1, MAX_Y]);
    Obst_xT = randi([1, MAX_X]);
    Obst_yT = randi([1, MAX_Y]);
    
    % 确保移动障碍物的起点和终点不在障碍物上且不与起点和目标点重合
    while is_point_on_obstacle(Obst_xS, Obst_yS, Obs_Closed) || ...
          is_point_on_obstacle(Obst_xT, Obst_yT, Obs_Closed) || ...
          (Obst_xS == xStart && Obst_yS == yStart) || ...
          (Obst_xT == xStart && Obst_yT == yStart) || ...
          (Obst_xS == xTarget && Obst_yS == yTarget) || ...
          (Obst_xT == xTarget && Obst_yT == yTarget)
          
        Obst_xS = randi([1, MAX_X]);
        Obst_yS = randi([1, MAX_Y]);
        Obst_xT = randi([1, MAX_X]);
        Obst_yT = randi([1, MAX_Y]);
    end
    
    % 计算移动障碍物的路径
    Obst_d_d_St=[Obst_xS Obst_yS];
    Obst_d_d_Ta=[Obst_xT Obst_yT];
    [Obst_d_path,~,~]=Astar_G(Obs_Closed,Obst_d_d_St,Obst_d_d_Ta,MAX_X,MAX_Y);
    Obst_d_path_X=[Obst_d_path;Obst_d_d_Ta];
    Obst_d_d_line=Line_obst(Obst_d_path_X,L_obst);
    
    % 随机设置未知静止障碍物
    Obs_d_j = [];
    num_static_obs = randi([0, 10]); % 随机生成0到10个静止障碍物
    
    for i = 1:num_static_obs
        valid_obs = false;
        while ~valid_obs
            x_obs = randi([1, MAX_X]);
            y_obs = randi([1, MAX_Y]);
            
            % 确保静止障碍物不在已有障碍物上，也不与起点和目标点重合
            if ~is_point_on_obstacle(x_obs, y_obs, Obs_Closed) && ...
               ~is_point_on_obstacle(x_obs, y_obs, Obs_d_j) && ...
               (x_obs ~= xStart || y_obs ~= yStart) && ...
               (x_obs ~= xTarget || y_obs ~= yTarget)
                
                Obs_d_j = [Obs_d_j; x_obs, y_obs];
                valid_obs = true;
            end
        end
    end
    
    % 运行A*+DWA算法并添加超时判断
    Area_MAX(1,1)=MAX_X;
    Area_MAX(1,2)=MAX_Y;
    path_node=Line_path;
    
    try
        % 记录开始时间
        start_time = tic;
        timeout = false;
        
        % 创建一个临时函数，用于在超时后终止DWA算法
        timeout_func = @(src, event) assignin('base', 'timeout', true);
        timer_h = timer('TimerFcn', timeout_func, 'StartDelay', timeout_threshold);
        start(timer_h);
        
        % 调用DWA算法，传入超时标志函数
        Result_x = DWA_ct_dong(Obs_Closed, Obst_d_d_line, Obs_d_j, Area_MAX, Goal, Line_path, path_node, Start, angle_node, Kinematic, evalParam, @() timeout);
        
        % 停止计时器
        stop(timer_h);
        delete(timer_h);
        % 计算执行时间
        execution_time = toc(start_time);
        results(exp_idx, 7) = execution_time;
        
        % 计算路径长度
        S=0;
        num_x=size(Result_x,1);
        for i=1:1:(num_x-1)
            Dist=sqrt( ( Result_x(i,1) - Result_x(i+1,1) )^2 + ( Result_x(i,2) - Result_x(i+1,2))^2);
            S=S+Dist;
        end
        results(exp_idx, 5) = S;
        
        % 计算转折度数
        angle_du=0;
        for i=1:1:(num_x-2)
            du=angle6(Result_x(i,1), Result_x(i,2), Result_x(i+1,1), Result_x(i+1,2), Result_x(i+2,1), Result_x(i+2,2));
            angle_du=angle_du+du;
        end
        results(exp_idx, 6) = angle_du;
        
        % 计算速度和角速度的平滑性
        vel_smoothness = calculate_smoothness(Result_x(:,4)); % 线速度平滑性
        ang_smoothness = calculate_smoothness(Result_x(:,5)); % 角速度平滑性
        
        % 检查是否成功到达目标点附近
        if norm([Result_x(end,1), Result_x(end,2)] - [xTarget, yTarget]) < 1.5
            results(exp_idx, 8) = 1; % 成功
            fprintf('实验 %d/%d 成功: 路径长度=%.2f, 转折度数=%.2f, 时间=%.2f秒\n', ...
                    exp_idx, num_experiments, S, angle_du, execution_time);
        else
            results(exp_idx, 8) = 0; % 失败
            fprintf('实验 %d/%d 失败（未到达目标）: 路径长度=%.2f, 转折度数=%.2f, 时间=%.2f秒\n', ...
                    exp_idx, num_experiments, S, angle_du, execution_time);
        end
        
    catch e
        % 如果算法运行出错或超时，标记为失败
        if exist('timer_h', 'var') && isvalid(timer_h)
            stop(timer_h);
            delete(timer_h);
        end
        
        if strcmp(e.identifier, 'MATLAB:timeout')
            results(exp_idx, 5:8) = [0, 0, timeout_threshold, 0];
            fprintf('实验 %d/%d 失败（超时）: 超过 %d 秒\n', exp_idx, num_experiments, timeout_threshold);
        else
            results(exp_idx, 5:8) = [0, 0, toc(start_time), 0];
            fprintf('实验 %d/%d 失败（错误）: %s\n', exp_idx, num_experiments, e.message);
        end
    end
end

% 计算成功率
success_rate = sum(results(:,8)) / num_experiments * 100;
fprintf('成功率: %.2f%%\n', success_rate);

% % 输出结果到Excel
% [~,~,sheet]=xlsread('实验结果.xlsx');
% xlswrite('实验结果.xlsx', {'实验序号', '起点X', '起点Y', '目标X', '目标Y', '路径长度', '转折度数', '执行时间(秒)', '是否成功'}, sheet, 'A1');
% xlswrite('实验结果.xlsx', [1:num_experiments, results], sheet, 'A2');
% xlswrite('实验结果.xlsx', {'成功率(%)', success_rate}, sheet, 'A' + num_experiments + 3);
% 
% % 显示实验完成消息
% h=msgbox(['实验完成! 共进行 ', num2str(num_experiments), ' 次实验，成功率为 ', num2str(success_rate), '%。结果已保存到Excel文件中。']);
% uiwait(h,10);
% if ishandle(h) == 1
%     delete(h);
% end
% 输出结果到Excel
% 假设工作表名称为 'Sheet1'
%%
sheet_name = 'Sheet1'; 
% 读取Excel文件中的数据
[~,~,~]=xlsread('实验结果.xlsx'); 

%  results 是一个 num_experiments 行的矩阵
% 将 1:num_experiments 转换为列向量
experiment_numbers = (1:num_experiments)';

% 确保 experiment_numbers 和 results 的行数一致
if size(experiment_numbers, 1) ~= size(results, 1)
    error('实验序号和结果的行数不一致');
end

% 水平连接实验序号和结果
combined_data = [experiment_numbers, results];

% 写入表头
xlswrite('实验结果.xlsx', {'实验序号', '起点X', '起点Y', '目标X', '目标Y', '路径长度', '转折度数', '执行时间(秒)', '是否成功'}, sheet_name, 'A1');
% 写入实验数据
xlswrite('实验结果.xlsx', combined_data, sheet_name, 'A2');
% 写入成功率
xlswrite('实验结果.xlsx', {'成功率(%)', success_rate}, sheet_name, ['A' num2str(num_experiments + 3)]);

% 显示实验完成消息
h=msgbox(['实验完成! 共进行 ', num2str(num_experiments), ' 次实验，成功率为 ', num2str(success_rate), '%。结果已保存到Excel文件中。']);
uiwait(h,10);
if ishandle(h) == 1
    delete(h);
end
%%

%evaluate_path_planning_performance('实验结果input.xlsx','实验结果1input.xlsx');




