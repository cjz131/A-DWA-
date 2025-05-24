function [u,trajDB]=DynamicWindowApproach_ct(x,model,goal,evalParam,ob,R)
% Dynamic Window [vmin,vmax,wmin,wmax]
% model= [    最高速度[m/s], 最高旋转速度[rad/s], 加速度[m/ss], 旋转加速度[rad/ss], 速度分辨率[m/s], 转速分辨率[rad/s]  ]
% x=[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
Vr=CalcDynamicWindow(x,model);
%  Vr=[ 0.1s后最低速度 0.1s后最高速度 0.1s后最低加速度 0.1s后最高加速度 ]
% 评价函数的计算
[evalDB,trajDB]=Evaluation_ct(x,Vr,goal,ob,R,model,evalParam);
 %  % evalDB=[ （第一组 v w ）预测的速度 转速 3s后的夹角 3s后的障碍物距离 3s后的速度值 ;
 %             （第二组 v w ）预测的速度 转速 3s后的夹角 3s后的障碍物距离 3s后的速度值 ; 
 %              。。。 ]
 % % trajDB = [ （第一组 v w ）3s内的所有状态轨迹 31个点 1-5行31列；
 %              （第二组 v w ）3s内的所有状态轨迹 31个点 6-10行31列;
 %              。。。 ]
if isempty(evalDB)   %  isempty 判断是否为空
    disp('no path to goal!!');
    u=[0;0];return;
end
% 各评价函数正则化
evalDB=NormalizeEval_ct(evalDB);
% evalDB=[ 预测的速度 转速 夹角平均值 障碍物距离平均值 速度值平均值  ]
%    evalDB=[ （第一组 v w ）预测的速度 转速 3s后的夹角/所有组的总夹角（比重） 3s后的障碍物距离/所有组的总距离（比重） 3s后的速度值/所有组的总速度（比重） ;
%             （第二组 v w ）预测的速度 转速 3s后的夹角/所有组的总夹角（比重） 3s后的障碍物距离/所有组的总距离（比重） 3s后的速度值/所有组的总速度（比重） ; 
%              。。。 ]
feval=[]; % 最终评价函数的计算
for id=1:length(evalDB(:,2))
    feval=[feval;evalParam(1:3)*evalDB(id,3:5)'];
    % evalParam=[0.05,  0.2,  0.1,  3.0]; 0.3 0.1 0.1
    % evalDB=[ 预测的速度 转速 夹角比重 障碍物距离比重 速度值比重  ] 
    % feval=[（每组） 夹角比重*系数 障碍物距离比重*系数 速度值比重*系数 ]
end
evalDB=[evalDB feval];
 
[maxv,ind]=max(feval);% 最优评价函数
u=evalDB(ind,1:2)';% 