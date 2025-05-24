function dist=CalcDistEval(x,ob,R)
% 障碍物距离评价函数
dist=200;
for io=1:length(ob(:,1))
    disttmp=norm(ob(io,:)-x(1:2)')-R;% 障碍物横纵坐标 - 当前点坐标norm求斜线长度
    if dist>disttmp% 100以下的距离 就赋值  离障碍物最小的距离
        dist=disttmp;
    end
end
 
% 障碍物距离评价限定一个最大值，如果不设定，一旦一条轨迹没有障碍物，将太占比重
if dist>=R
    dist=R;
end