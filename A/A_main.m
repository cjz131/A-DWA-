%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 改进A* 与 传统A*算法 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear;
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A* 算法 判断参数 A
A=1;
Dij_A=1; % Dij_A=1 表示 搜索空间的栅格用灰色表示出来，Dij_A=0 不表示 
% 改进A*算法 判断参数 A_g
A_g=1;
Dij_Ag=1; % Dij_Ag=1 表示 搜索空间的栅格用灰色表示出来，Dij_Ag=0 不表示 
%% 设置地图
%   %%%只能设置正方形矩阵，行和列相等，否则旋转时会出现错误
%   1 表示障碍物  0  表示空白区域  ｛可自行修改｝
%  实验地图1 
MAX0= [     0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0
             0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0
             0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 1 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 1 1 1 1 1 1 1 0 0 0 1 1 0 0
             0 0 1 1 0 0 0 1 1 1 1 1 1 0 1 0 1 1 0 0 
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 
             0 0 0 1 1 0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 
             0 0 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 
             1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
             1 1 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 ] ;
%%  栅格地图处理
MAX=MAX0;      %%%设置0,1摆放的图像与存入的数组不一样，需要先逆时针旋转90*3=270度给数组，最后输出来的图像就是自己编排的图像
MAX_X=size(MAX,2);                                %%%  获取列数，即x轴长度
MAX_Y=size(MAX,1);                                %%%  获取行数，即y轴长度
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  设置x，y轴上下限
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',... 
    'xGrid','on','yGrid','on')
grid on;                                   %%%  在画图的时候添加网格线
hold on;                                   %%%  当前轴及图像保持而不被刷新，准备接受此后将绘制的图形，多图共存
n=0;%Number of Obstacles                   %%%  障碍的数量

k=1;          %%%% 将所有障碍物放在关闭列表中；障碍点的值为1;并且显示障碍点
CLOSED=[];
for j=1:MAX_X
    for i=1:MAX_Y
        if (MAX(i,j)==1)
          fill([i,i+1,i+1,i],[j,j,j+1,j+1],'k');  %%%用黑方块来表示障碍物
          CLOSED(k,1)=i;  %%% 将障碍点保存到CLOSE数组中
          CLOSED(k,2)=j; 
          k=k+1;
        end
    end
end
%% 设置起始点、目标点
%%%   选择目标位置
pause(0.5);                                                    %%%   程序暂停1秒
h=msgbox('请使用鼠标左键选择待检测设备');                       %%%   鼠标选择目标
uiwait(h,5);                                                   %%%   程序暂停
if ishandle(h) == 1                                            %%%   ishandle(H) 将返回一个元素为 1 的数组；否则，将返回 0。
    delete(h);
end
xlabel('请使用鼠标左键选择待检测设备','Color','black');         %%%   显示图x坐标下面的提示语 
but=0;
while (but ~= 1)                                               %%%  重复，直到没有单击 向左 按钮
    [xval,yval,but]=ginput(1);                                 %%%  ginput提供了一个十字光标使我们能更精确的选择我们所需要的位置，并返回坐标值。
end
xval=floor(xval);                                              %%%  floor（）取不大于传入值的最大整数，向下取整
yval=floor(yval);
xTarget=xval;                                                  %%%   目标的x坐标
yTarget=yval;                                                  %%%   目标的y坐标
plot(xval+.5,yval+.5,'ro');                                    %%%   目标点颜色b 蓝色 g 绿色 k 黑色 w白色 r 红色 y黄色 m紫红色 c蓝绿色
text(xval+1,yval+1,'Target')                                   %%%   text(x,y,'string')在二维图形中指定的位置(x,y)上显示字符串string

%%%   选择起始位置
h=msgbox('请使用鼠标左键选择巡检机器人初始位置');               %%%请使用鼠标左键选择巡检机器人初始位置
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('请选择巡检机器人初始位置 ','Color','black');           %%% 请选择巡检机器人初始位置
but=0;
while (but ~= 1)                                              %%%重复，直到没有单击"向左"按钮
    [xval,yval,but]=ginput(1);
    xval=floor(xval);
    yval=floor(yval);
end
xStart=xval;                                                  %%%   巡检机器人的x坐标
yStart=yval;                                                  %%%   巡检机器人的y坐标
plot(xval+.5,yval+.5,'y*');
text(xval+1,yval+1,'Start')  
xlabel('起始点位置标记为 * ，目标点位置标记为 o ','Color','black'); 

%% A* 算法  路径规划
if  A==1
   A1_path=A_1(MAX,xStart,yStart,xTarget,yTarget,CLOSED,Dij_A) ; 
end

%% 改进A*算法  路径规划
% 改进A*算法   1  8个搜索方向变成 5个  提高搜索方向
%             2  无斜穿障碍物顶点  避免发生碰撞
%             3  基于改进folyd双向平滑度优化，删除中间多余节点，减少转折，增加路径的平滑度
%             4  评价函数：f(n)=g(n)+(1-log(P))*h(n) 
%                           P表示起始点与目标点之间的障碍率
%                            = 障碍物的数量/栅格总数
%                          其中r为当前点到目标点的距离，R为起始点到目标点的距离。
%              
if  A_g==1
   A7_path=A_2(MAX,xStart,yStart,xTarget,yTarget,CLOSED,Dij_A) ;  
end
%% 画图 f=1 将所有路径放在一个地图里面 ；f=0 省略
f=1;
if f==1
figure
MAX_X=size(MAX,2);                                %%%  获取列数，即x轴长度
MAX_Y=size(MAX,1);                                %%%  获取行数，即y轴长度
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  设置x，y轴上下限
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',... 
    'xGrid','on','yGrid','on')
grid on;                                   %%%  在画图的时候添加网格线
hold on;                                   %%%  当前轴及图像保持而不被刷新，准备接受此后将绘制的图形，多图共存
% 
plot(xTarget+.5,yTarget+.5,'ro'); 
% 
plot(xStart+.5,yStart+.5,'y*');


for j=1:MAX_X
    for i=1:MAX_Y
        if (MAX(i,j)==1)
          fill([i,i+1,i+1,i],[j,j,j+1,j+1],'k');  %%%改成 用黑方块来表示障碍物
        end
    end
end

if  A==1
   plot(A1_path(:,1)+.5,A1_path(:,2)+.5,'linewidth',2); %5%绘线
end
if  A_g==1
   plot(A7_path(:,1)+.5,A7_path(:,2)+.5,'linewidth',2); %5%绘线  
end
end

