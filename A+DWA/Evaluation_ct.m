function [evalDB,trajDB]=Evaluation_ct(x,Vr,goal,ob,R,model,evalParam)
% 
%   Vr=[ 0.1s后最低速度 0.1s后最高速度 0.1s后最低加速度 0.1s后最高加速度 ]
% model= [   最高速度[m/s], 最高旋转速度[rad/s], 加速度[m/ss], 旋转加速度[rad/ss], 速度分辨率[m/s], 转速分辨率[rad/s]  ]
evalDB=[];
trajDB=[];
for vt=Vr(1):model(5):Vr(2) % 最低速度：速度分辨率：最高速度
    for ot=Vr(3):model(6):Vr(4) % 最低加速度：转速分辨率：最高加速度
        % 轨迹推测; 得到 xt: 机器人向前运动后的预测位姿; traj: 当前时刻 到 预测时刻之间的轨迹
        [xt,traj]=GenerateTrajectory(x,vt,ot,evalParam(4),model);  % evalParam(4) = 3
        % 每组[vt ot]在3秒内的运动轨迹，取31个点    
        % traj=3s内的所有状态轨迹； xt=3s后的状态轨迹
        %evalParam(4),前向模拟时间; % 评价函数参数 [heading,dist,velocity,predictDT]
        % [xt,traj] = [预测的当前状态，所有状态数组  ]  % 各评价函数的计算
        heading=CalcHeadingEval(xt,goal); % 计算3s后的偏角与目标点的夹角a pi-a
        dist=CalcDistEval(xt,ob,R); % 计算3s后的位置 与障碍物最小距离 （有最大值限制）
        vel=abs(vt); % abs 去绝对值
        % 制动距离的计算 vel= 推测速度的大小
        stopDist=CalcBreakingDist(vel,model);% 制动距离 必须小于与障碍物的距离
        
        %%%%%%%     计算预测点 到 动态障碍物 的距离       ****
        
        
        if dist>stopDist % 
            evalDB=[evalDB;[vt ot heading dist vel]]; 
            % evalDB=[ （第一组 v w ）预测的速度 转速 3s后的夹角 3s后的障碍物距离 3s后的速度值 ;（第二组 v w ）预测的速度 转速 3s后的夹角 3s后的障碍物距离 3s后的速度值 ; 。。。]
            trajDB=[trajDB;traj]; % trajDB = [ （第一组 v w ）3s内的所有状态轨迹 31个点 1-5行31列；（第二组 v w ）3s内的所有状态轨迹 31个点 6-10行31列]
        end
    end
end