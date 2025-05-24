function [x,traj]=GenerateTrajectory(x,vt,ot,evaldt,model)
% 轨迹生成函数
%  evaldt：前向模拟时间; vt、ot当前速度和角速度; 评价函数参数 [heading,dist,velocity,predictDT]
global dt;
time=0;
u=[vt;ot];% 输入值
traj=x;% 机器人轨迹
while time<=evaldt % evaldt=evalParam(4) = 3   0:0.1:3  30次循环
    time=time+dt;% 时间更新0.1 30 
    x=f(x,u);% 运动更新  0.1s后的状态
    
    traj=[traj x];% traj=3s内的所有状态轨迹； x=3s后的状态轨迹
end