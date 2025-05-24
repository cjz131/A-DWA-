clc
clear
figure 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                地图建模
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%只能设置正方形矩阵，行和列相等，否则旋转时会出现错误
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
%%% 通道设置为 0 ；障碍点设置为 1 ；起始点设置为 2 ；目标点设置为 -1 。
MAX=rot90(MAX0,3);      %%%设置0,1摆放的图像与存入的数组不一样，需要先逆时针旋转90*3=270度给数组，最后输出来的图像就是自己编排的图像
MAX_X=size(MAX,2);                                %%%  获取列数，即x轴长度
MAX_Y=size(MAX,1);                                %%%  获取行数，即y轴长度
MAX_VAL=10;                              %%%   返回由数字组成的字符表达式的数字值，就是函数用于将数值字符串转换为数值

x_val = 1;
y_val = 1;
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
          %%plot(i+.5,j+.5,'ks','MarkerFaceColor','b'); 原来是红点圆表示
          fill([i,i+1,i+1,i],[j,j,j+1,j+1],'k');  %%%改成 用黑方块来表示障碍物
          CLOSED(k,1)=i;  %%% 将障碍点保存到CLOSE数组中
          CLOSED(k,2)=j; 
          k=k+1;
        end
    end
end
Area_MAX(1,1)=MAX_X;
Area_MAX(1,2)=MAX_Y;
Obs_Closed=CLOSED;
num_Closed=size(CLOSED,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                       设置起始点和多个目标点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 设置起始点、目标点
%%%   选择目标位置
pause(0.5);                                  %%%   程序暂停1秒
h=msgbox('请使用鼠标左键选择电气设备位置');          %%%   Please Select the Target using the Left Mouse button
uiwait(h,5);                               %%%   程序暂停
if ishandle(h) == 1                        %%%   ishandle(H) 将返回一个元素为 1 的数组；否则，将返回 0。
    delete(h);
end
xlabel('请使用鼠标左键选择电气设备位置','Color','black');   %%%   Please Select the Target using the Left Mouse button
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked  %%%  重复，直到没有单击“向左”按钮
    [xval,yval,but]=ginput(1);                                 %%%  ginput提供了一个十字光标使我们能更精确的选择我们所需要的位置，并返回坐标值。
end
xval=floor(xval);                                              %%%  floor（）取不大于传入值的最大整数，向下取整
yval=floor(yval);
xTarget=xval;%X Coordinate of the Target                       %%%   目标的坐标
yTarget=yval;%Y Coordinate of the Target
plot(xval+.5,yval+.5,'go');                                    %%%   目标点颜色b 蓝色 g 绿色 k 黑色 w白色 r 红色 y黄色 m紫红色 c蓝绿色
text(xval+1,yval+1,'Target')                                  %%%   text(x,y,'string')在二维图形中指定的位置(x,y)上显示字符串string

%%%   选择起始位置
h=msgbox('请使用鼠标左键选择巡检机器人初始位置');                    %%%Please Select the Vehicle initial position using the Left Mouse button
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('请选择巡检机器人初始位置 ','Color','black');                %%%  Please Select the Vehicle initial position
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked %%%重复，直到没有单击“向左”按钮
    [xval,yval,but]=ginput(1);
    xval=floor(xval);
    yval=floor(yval);
end
xStart=xval;%Starting Position
yStart=yval;%Starting Position
plot(xval+.5,yval+.5,'b^');
text(xval+1,yval+1,'Start')  
xlabel('起始点位置标记为 △ ，目标点位置标记为 o ','Color','black'); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Start=[xStart yStart];
Goal=[xTarget yTarget];

[Line_path,distance_x,OPEN_num]=Astar_G_du(Obs_Closed,Start,Goal,MAX_X,MAX_Y);
%Line_path=[3,11;5,14;7,17;9,17;11,17;13,17;15,17;18,11]
%                                     局部避障
figure 
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  设置x，y轴上下限
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',...
        'xGrid','on','yGrid','on');   
grid on;       
hold on;
num_obc=size(Obs_Closed,1);
for i_obs=1:1:num_obc
         x_obs=Obs_Closed(i_obs,1);
         y_obs=Obs_Closed(i_obs,2);
         fill([x_obs,x_obs+1,x_obs+1,x_obs],[y_obs,y_obs,y_obs+1,y_obs+1],'k');hold on;
end
 plot( Line_path(:,1)+.5, Line_path(:,2)+.5,'b:','linewidth',2); 
 plot(xStart+.5,yStart+.5,'b^');
 plot(Goal(1,1)+.5,Goal(1,2)+.5,'bo');   
% 
pause(1);
h=msgbox('设置移动障碍物的 起点');
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('设置移动障碍物的 起点','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
end
xval=floor(xval);
yval=floor(yval);
Obst_xS=xval;%X Coordinate of the Target
Obst_yS=yval;%Y Coordinate of the Target

plot(xval+.5,yval+.5,'k^');
 
pause(1);

h=msgbox('设置移动障碍物的 终点');
uiwait(h,5);
if ishandle(h) == 1
    delete(h);
end
xlabel('设置移动障碍物的 终点 ','Color','black');
but=0;
while (but ~= 1) %Repeat until the Left button is not clicked
    [xval,yval,but]=ginput(1);
    xval=floor(xval);
    yval=floor(yval);
end
Obst_xT=xval;%Starting Position
Obst_yT=yval;%Starting Position
 plot(xval+.5,yval+.5,'ko');
 Obst_d_d_St=[Obst_xS Obst_yS];
Obst_d_d_Ta=[Obst_xT Obst_yT];
[Obst_d_path,Obst_d_distance_x,Obst_d_OPEN_num]=Astar_G_du(Obs_Closed,Obst_d_d_St,Obst_d_d_Ta,MAX_X,MAX_Y);
Obst_d_path_X=[Obst_d_path;Obst_d_d_Ta];
L_obst=0.026;% 设置移动障碍物的速度 0.1s内运动 L_obst m  速度为10*L_obst m/s
Obst_d_d_line=Line_obst(Obst_d_path_X,L_obst);
plot( Obst_d_d_line(:,1)+.5, Obst_d_d_line(:,2)+.5,'r','linewidth',1); 

pause(1);
h=msgbox('设置未知静止障碍物 左键确定后继续设置，右键确定后结束');
  xlabel('设置未知静止障碍物 左键确定后继续设置，右键确定后结束','Color','blue');
uiwait(h,10);
if ishandle(h) == 1
    delete(h);
end
but=1;
while but == 1
    [xval,yval,but] = ginput(1);
    xval=floor(xval);
    yval=floor(yval);
    MAX(xval,yval)=8;%Put on the closed list as well
    %plot(xval+.5,yval+.5,'rp');
    fill([xval,xval+1,xval+1,xval],[yval,yval,yval+1,yval+1],[0.8 0.8 0.8]); 
 end%End of While loop

dg=0;%Dummy counter
Obs_d_j=[0 0 ];
for i=1:MAX_X
    for j=1:MAX_Y
        if(MAX(i,j) == 8)
            dg=dg+1;
            Obs_d_j(dg,1)=i; 
            Obs_d_j(dg,2)=j; 
        end
    end
end

%% 机器人运动学模型
% 机器人初始方向角度 s_du
angle_node=pi/4;
% 机器人速度参数
% Kinematic = [   最高速度[m/s], 最高旋转速度[rad/s], 加速度[m/ss], 旋转加速度[rad/ss], 速度分辨率[m/s], 转速分辨率[rad/s]  ]

Kinematic=[1.5,toRadian(20.0),0.2,toRadian(50.0),0.02,toRadian(1)];
% 评价函数系数设置 [heading,dist,velocity,predictDT]
%  [方位角评价函数系数， 障碍物距离评价函数系数， 当前速度大小评价函数系数, 预测是时间 （不变）]
evalParam=[0.05,0.2,0.3,3.0];%


path_node=Line_path;
Result_x=DWA_ct_dong(Obs_Closed,Obst_d_d_line,Obs_d_j,Area_MAX,Goal,Line_path,path_node,Start,angle_node,Kinematic,evalParam);

%%%%%%%%%%% 画图
figure 
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  设置x，y轴上下限
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',...
        'xGrid','on','yGrid','on');   
grid on;       
hold on;

 for i_obs=1:1:num_obc
         x_obs=Obs_Closed(i_obs,1);
         y_obs=Obs_Closed(i_obs,2);
         fill([x_obs,x_obs+1,x_obs+1,x_obs],[y_obs,y_obs,y_obs+1,y_obs+1],'k');hold on;
 end
 plot( Line_path(:,1)+.5, Line_path(:,2)+.5,'b:','linewidth',1.5); 
 plot(xStart+.5,yStart+.5,'b^');
 plot(Goal(1,1)+.5,Goal(1,2)+.5,'bo');
  num_o=size(Obst_d_d_line,1);
 x_do=Obst_d_d_line(num_o,1);
 y_do=Obst_d_d_line(num_o,2);
 fill([x_do+0.15,x_do+0.85,x_do+0.85,x_do+0.15],[y_do+0.15,y_do+0.15,y_do+0.85,y_do+0.85],'y');
 num_lin=size(Line_path,1);
 for i_lin=2:1:num_lin-1
     plot(Line_path(i_lin,1)+.5,Line_path(i_lin,2)+.5,'r*');
 end

%     dong_num=size(Obs_d_j,1);
%     for i_d=1:1:dong_num
%       x_do=Obs_d_j(i_d,1);
%       y_do=Obs_d_j(i_d,2);
%       fill([x_do,x_do+1,x_do+1,x_do],[y_do,y_do,y_do+1,y_do+1],[0.8 0.8 0.8]);
%     end
num_x=size(Result_x,1);
Result_plot=[Result_x;Goal(1,1) Goal(1,2) Result_x(num_x,3) 0 0];


 plot(Result_x(:,1)+0.5, Result_x(:,2)+0.5,'b','linewidth',2);hold on;
 num_p=num_x+1;
 ti=1:1:num_p;
 figure
 plot(ti,Result_plot(:,3),'-b');hold on;
 legend('姿态角度')
 figure
 plot(ti,Result_plot(:,4),'-b');hold on;
 
 plot(ti,Result_plot(:,5),'-r');hold on;
 legend('线速度','角速度')
  S=0;
 for i=1:1:num_x  %%%% 求路径所用的实际长度
     Dist=sqrt( ( Result_plot(i,1) - Result_plot(i+1,1) )^2 + ( Result_plot(i,2) - Result_plot(i+1,2))^2);
     S=S+Dist;
 end
disp('路径长度')
 S
%  
%  % 机器人的状态Result_x=[x(m),y(m),yaw(Rad),v(m/s),w(rad/s)]
%  i=1
%  figure
%  axis([0 2000, -0.4 0.8])                %%%  设置x，y轴上下限
%  set(gca,'xtick',0:100:2100,'ytick',-0.4:0.2:0.8,'GridLineStyle','-',... 
%     'xGrid','on','yGrid','on')
%  grid off;
% xlabel('控制节点个数');hold on
% ylabel('线速度(m/s) 角速度(rad/s)');hold on
% 
% plot(ti,Result_plot(:,4),'-b','linewidth',1.5);hold on;
% plot(ti,Result_plot(:,5),':r','linewidth',1.5);hold on;

 
 
 