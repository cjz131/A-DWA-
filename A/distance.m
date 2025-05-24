function dist = distance(x1,y1,x2,y2)
%This function calculates the distance between any two cartesian 
% coordinates.
%此函数计算任意两个笛卡尔坐标之间的欧几里得距离。
%   Copyright 2009-2010 The MathWorks, Inc.
dist=sqrt((x1-x2)^2 + (y1-y2)^2);
%  还有 曼哈顿距离 h(n) = abs(nx - goalx) + abs(ny - goaly)
%       切比雪夫距离 h(n) = max[abs(nx - goalx),abs(ny - goaly)