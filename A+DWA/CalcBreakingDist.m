function stopDist=CalcBreakingDist(vel,model)
% 
global dt;
stopDist=0;
while vel>0
    stopDist=stopDist+vel*dt;% �ƶ��������
    vel=vel-model(3)*dt;% 
end