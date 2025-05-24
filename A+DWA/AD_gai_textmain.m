% ��ջ���
clc
clear
rng('shuffle'); % ������������ӣ�ȷ�����������

% ��ͼ��ģ
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

% ��ʼ���ϰ����б�
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

% ����ʵ�����
num_experiments = 100; % ʵ�����
results = zeros(num_experiments, 8); % �洢ʵ���� [���x, ���y, Ŀ��x, Ŀ��y, ·������, ת�۶���, ִ��ʱ��, �ɹ���]

% ��ʾʵ�鿪ʼ��Ϣ
h=msgbox(['��ʼ���� ', num2str(num_experiments), ' �����ʵ�飬�����ĵȴ�...']);
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end

% �����˲�������
angle_node=pi/4;
Kinematic=[1.5,toRadian(20.0),0.2,toRadian(50.0),0.02,toRadian(1)];
evalParam=[0.05,0.2,0.3,3.0];

% �ƶ��ϰ����������
L_obst=0.026; % �ƶ��ϰ����ٶ�
timeout_threshold = 300; % ��ʱ��ֵ���룩

% ʵ��ѭ��
for exp_idx = 1:num_experiments
    % �����������Ŀ���
    valid_points = false;
    max_attempts = 100;
    attempt = 0;
    
    while ~valid_points && attempt < max_attempts
        attempt = attempt + 1;
        
        % �����������Ŀ���
        xStart = randi([1, MAX_X]);
        yStart = randi([1, MAX_Y]);
        xTarget = randi([1, MAX_X]);
        yTarget = randi([1, MAX_Y]);
        
        % �������Ŀ����Ƿ����ϰ�����
        if ~is_point_on_obstacle(xStart, yStart, Obs_Closed) && ...
           ~is_point_on_obstacle(xTarget, yTarget, Obs_Closed) && ...
           (xStart ~= xTarget || yStart ~= yTarget) % ȷ������Ŀ��㲻��ͬ
           
            % ʹ��A*�㷨��������Ƿ�ɴ�
            Start=[xStart yStart];
            Goal=[xTarget yTarget];
            [Line_path,~,~]=Astar_G(Obs_Closed,Start,Goal,MAX_X,MAX_Y);
            
            if ~isempty(Line_path) % ���·����Ϊ�գ���ʾ����ɴ�
                valid_points = true;
            end
        end
    end
    
    if ~valid_points
        % ����޷��ҵ���Ч������Ŀ��㣬��������ʵ��
        results(exp_idx, :) = [xStart, yStart, xTarget, yTarget, 0, 0, 0, 0];
        fprintf('ʵ�� %d/%d: �޷��ҵ���Ч������Ŀ���\n', exp_idx, num_experiments);
        continue;
    end
    
    % ��������Ŀ���
    results(exp_idx, 1:4) = [xStart, yStart, xTarget, yTarget];
    
    % ��������ƶ��ϰ���������յ�
    Obst_xS = randi([1, MAX_X]);
    Obst_yS = randi([1, MAX_Y]);
    Obst_xT = randi([1, MAX_X]);
    Obst_yT = randi([1, MAX_Y]);
    
    % ȷ���ƶ��ϰ���������յ㲻���ϰ������Ҳ�������Ŀ����غ�
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
    
    % �����ƶ��ϰ����·��
    Obst_d_d_St=[Obst_xS Obst_yS];
    Obst_d_d_Ta=[Obst_xT Obst_yT];
    [Obst_d_path,~,~]=Astar_G(Obs_Closed,Obst_d_d_St,Obst_d_d_Ta,MAX_X,MAX_Y);
    Obst_d_path_X=[Obst_d_path;Obst_d_d_Ta];
    Obst_d_d_line=Line_obst(Obst_d_path_X,L_obst);
    
    % �������δ֪��ֹ�ϰ���
    Obs_d_j = [];
    num_static_obs = randi([0, 10]); % �������0��10����ֹ�ϰ���
    
    for i = 1:num_static_obs
        valid_obs = false;
        while ~valid_obs
            x_obs = randi([1, MAX_X]);
            y_obs = randi([1, MAX_Y]);
            
            % ȷ����ֹ�ϰ��ﲻ�������ϰ����ϣ�Ҳ��������Ŀ����غ�
            if ~is_point_on_obstacle(x_obs, y_obs, Obs_Closed) && ...
               ~is_point_on_obstacle(x_obs, y_obs, Obs_d_j) && ...
               (x_obs ~= xStart || y_obs ~= yStart) && ...
               (x_obs ~= xTarget || y_obs ~= yTarget)
                
                Obs_d_j = [Obs_d_j; x_obs, y_obs];
                valid_obs = true;
            end
        end
    end
    
    % ����A*+DWA�㷨����ӳ�ʱ�ж�
    Area_MAX(1,1)=MAX_X;
    Area_MAX(1,2)=MAX_Y;
    path_node=Line_path;
    
    try
        % ��¼��ʼʱ��
        start_time = tic;
        timeout = false;
        
        % ����һ����ʱ�����������ڳ�ʱ����ֹDWA�㷨
        timeout_func = @(src, event) assignin('base', 'timeout', true);
        timer_h = timer('TimerFcn', timeout_func, 'StartDelay', timeout_threshold);
        start(timer_h);
        
        % ����DWA�㷨�����볬ʱ��־����
        Result_x = DWA_ct_dong(Obs_Closed, Obst_d_d_line, Obs_d_j, Area_MAX, Goal, Line_path, path_node, Start, angle_node, Kinematic, evalParam, @() timeout);
        
        % ֹͣ��ʱ��
        stop(timer_h);
        delete(timer_h);
        % ����ִ��ʱ��
        execution_time = toc(start_time);
        results(exp_idx, 7) = execution_time;
        
        % ����·������
        S=0;
        num_x=size(Result_x,1);
        for i=1:1:(num_x-1)
            Dist=sqrt( ( Result_x(i,1) - Result_x(i+1,1) )^2 + ( Result_x(i,2) - Result_x(i+1,2))^2);
            S=S+Dist;
        end
        results(exp_idx, 5) = S;
        
        % ����ת�۶���
        angle_du=0;
        for i=1:1:(num_x-2)
            du=angle6(Result_x(i,1), Result_x(i,2), Result_x(i+1,1), Result_x(i+1,2), Result_x(i+2,1), Result_x(i+2,2));
            angle_du=angle_du+du;
        end
        results(exp_idx, 6) = angle_du;
        
        % �����ٶȺͽ��ٶȵ�ƽ����
        vel_smoothness = calculate_smoothness(Result_x(:,4)); % ���ٶ�ƽ����
        ang_smoothness = calculate_smoothness(Result_x(:,5)); % ���ٶ�ƽ����
        
        % ����Ƿ�ɹ�����Ŀ��㸽��
        if norm([Result_x(end,1), Result_x(end,2)] - [xTarget, yTarget]) < 1.5
            results(exp_idx, 8) = 1; % �ɹ�
            fprintf('ʵ�� %d/%d �ɹ�: ·������=%.2f, ת�۶���=%.2f, ʱ��=%.2f��\n', ...
                    exp_idx, num_experiments, S, angle_du, execution_time);
        else
            results(exp_idx, 8) = 0; % ʧ��
            fprintf('ʵ�� %d/%d ʧ�ܣ�δ����Ŀ�꣩: ·������=%.2f, ת�۶���=%.2f, ʱ��=%.2f��\n', ...
                    exp_idx, num_experiments, S, angle_du, execution_time);
        end
        
    catch e
        % ����㷨���г����ʱ�����Ϊʧ��
        if exist('timer_h', 'var') && isvalid(timer_h)
            stop(timer_h);
            delete(timer_h);
        end
        
        if strcmp(e.identifier, 'MATLAB:timeout')
            results(exp_idx, 5:8) = [0, 0, timeout_threshold, 0];
            fprintf('ʵ�� %d/%d ʧ�ܣ���ʱ��: ���� %d ��\n', exp_idx, num_experiments, timeout_threshold);
        else
            results(exp_idx, 5:8) = [0, 0, toc(start_time), 0];
            fprintf('ʵ�� %d/%d ʧ�ܣ�����: %s\n', exp_idx, num_experiments, e.message);
        end
    end
end

% ����ɹ���
success_rate = sum(results(:,8)) / num_experiments * 100;
fprintf('�ɹ���: %.2f%%\n', success_rate);

% % ��������Excel
% [~,~,sheet]=xlsread('ʵ����.xlsx');
% xlswrite('ʵ����.xlsx', {'ʵ�����', '���X', '���Y', 'Ŀ��X', 'Ŀ��Y', '·������', 'ת�۶���', 'ִ��ʱ��(��)', '�Ƿ�ɹ�'}, sheet, 'A1');
% xlswrite('ʵ����.xlsx', [1:num_experiments, results], sheet, 'A2');
% xlswrite('ʵ����.xlsx', {'�ɹ���(%)', success_rate}, sheet, 'A' + num_experiments + 3);
% 
% % ��ʾʵ�������Ϣ
% h=msgbox(['ʵ�����! ������ ', num2str(num_experiments), ' ��ʵ�飬�ɹ���Ϊ ', num2str(success_rate), '%������ѱ��浽Excel�ļ��С�']);
% uiwait(h,10);
% if ishandle(h) == 1
%     delete(h);
% end
% ��������Excel
% ���蹤��������Ϊ 'Sheet1'
%%
sheet_name = 'Sheet1'; 
% ��ȡExcel�ļ��е�����
[~,~,~]=xlsread('ʵ����.xlsx'); 

%  results ��һ�� num_experiments �еľ���
% �� 1:num_experiments ת��Ϊ������
experiment_numbers = (1:num_experiments)';

% ȷ�� experiment_numbers �� results ������һ��
if size(experiment_numbers, 1) ~= size(results, 1)
    error('ʵ����źͽ����������һ��');
end

% ˮƽ����ʵ����źͽ��
combined_data = [experiment_numbers, results];

% д���ͷ
xlswrite('ʵ����.xlsx', {'ʵ�����', '���X', '���Y', 'Ŀ��X', 'Ŀ��Y', '·������', 'ת�۶���', 'ִ��ʱ��(��)', '�Ƿ�ɹ�'}, sheet_name, 'A1');
% д��ʵ������
xlswrite('ʵ����.xlsx', combined_data, sheet_name, 'A2');
% д��ɹ���
xlswrite('ʵ����.xlsx', {'�ɹ���(%)', success_rate}, sheet_name, ['A' num2str(num_experiments + 3)]);

% ��ʾʵ�������Ϣ
h=msgbox(['ʵ�����! ������ ', num2str(num_experiments), ' ��ʵ�飬�ɹ���Ϊ ', num2str(success_rate), '%������ѱ��浽Excel�ļ��С�']);
uiwait(h,10);
if ishandle(h) == 1
    delete(h);
end
%%

%evaluate_path_planning_performance('ʵ����input.xlsx','ʵ����1input.xlsx');




