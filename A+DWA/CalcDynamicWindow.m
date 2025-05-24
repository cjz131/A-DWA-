function Vr=CalcDynamicWindow(x,model)
%
global dt;
% 车子速度的最大最小范围 
% model= [   最高速度[m/s], 最高旋转速度[rad/s], 加速度[m/ss], 旋转加速度[rad/ss], 速度分辨率[m/s], 转速分辨率[rad/s]  ]
Vs=[0 model(1) -model(2) model(2)];
% Vs=[ 0, 最高速度[m/s],  -最高旋转速度[rad/s], 最高旋转速度[rad/s]   ]
% 根据当前速度以及加速度限制计算的动态窗口
% x=[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]

Vd=[x(4)-model(3)*dt x(4)+model(3)*dt x(5)-model(4)*dt x(5)+model(4)*dt];
% Vd=[  v-at(0.1s后最低速度），v+at(0.1s后最高速度），w-bt(0.1s后最低加速度 ，w+bt(0.1s后最高加速度）]
% 最终的Dynamic Window
Vtmp=[Vs;Vd];
% Vtmp=[      0,                 最高速度[m/s],       -最高旋转速度[rad/s],   最高旋转速度[rad/s]  ;
%      v-at(0.1s后最低速度），v+at(0.1s后最高速度），w-bt(0.1s后最低加速度 ，  w+bt(0.1s后最高加速度）];
Vr=[max(Vtmp(:,1)) min(Vtmp(:,2)) max(Vtmp(:,3)) min(Vtmp(:,4))];
% 选出在限制条件下的速度范围
%  Vr=[ 0.1s后最低速度 0.1s后最高速度  0.1s后最低加速度 0.1s后最高加速度 ]