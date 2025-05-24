%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 
% 
% 传统A*算法
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%只能设置正方形矩阵，行和列相等，否则旋转时会出现错误
function Optimal_path=A_1(MAX,xStart,yStart,xTarget,yTarget,CLOSED,hui)
figure

MAX_X=size(MAX,2);                                %%%  获取列数，即x轴长度
MAX_Y=size(MAX,1);                                %%%  获取行数，即y轴长度
axis([1 MAX_X+1, 1 MAX_Y+1])                %%%  设置x，y轴上下限
set(gca,'xtick',1:1:MAX_X+1,'ytick',1:1:MAX_Y+1,'GridLineStyle','-',... 
    'xGrid','on','yGrid','on')
grid on;                                   %%%  在画图的时候添加网格线
hold on;                                   %%%  当前轴及图像保持而不被刷新，准备接受此后将绘制的图形，多图共存
% 


for j=1:MAX_X
    for i=1:MAX_Y
        if (MAX(i,j)==1)
          %%plot(i+.5,j+.5,'ks','MarkerFaceColor','b'); 原来是红点圆表示
          fill([i,i+1,i+1,i],[j,j,j+1,j+1],'k');  %%%改成 用黑方块来表示障碍物
          
        end
    end
end

tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM %%%用于算法的列表
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN LIST STRUCTURE  %%%开放列表结构
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];
%CLOSED LIST STRUCTURE %%% 封闭的列表结构
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2); %%% 生成MAX_VAL行，2列的0矩阵
CLOSED_COUNT=size(CLOSED,1);   %%% CLOSED的行数，即障碍点的个数 
xNode=xStart;      %%% =xStart
yNode=yStart;      %%% =yStart
OPEN_COUNT=1;    %%% OPEN_COUNT 开启列表的行数标志
path_cost=0;
goal_distance=distance(xNode,yNode,xTarget,yTarget);                                                                                    %%%  ***调用distance（）函数，求两坐标点之间的笛卡尔距离

OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,path_cost,goal_distance,goal_distance);  %%%   插入到开放列表
                            %%%        OPEN（第一行的元素）=（1，xNode,yNode,xNode,yNode,path_cost,goal_distance,goal_distanc）；
OPEN(OPEN_COUNT,1)=0;      %%%   OPEN(1,1)=0
CLOSED_COUNT=CLOSED_COUNT+1;  %%%   CLOSED 存储完障碍点后，下一个单元
CLOSED(CLOSED_COUNT,1)=xNode; %%%   下一个存储起始点的 坐标
CLOSED(CLOSED_COUNT,2)=yNode;
NoPath=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM 开始算法
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while((xNode ~= xTarget || yNode ~= yTarget) && NoPath == 1)       %%%  判断当前点是否等于目标点
%  plot(xNode+.5,yNode+.5,'go');
%  xnode=xNode,ynode=yNode  %%%****输出当前节点，用来学习了解A*算法的运算过程****  ///不需要知道过程可注释掉///
 
 exp_array=expand_array01(xNode,yNode,path_cost,xTarget,yTarget,CLOSED,MAX_X,MAX_Y);
 exp_count=size(exp_array,1);   %%%  可选择的子节点个数
 %UPDATE LIST OPEN WITH THE SUCCESSOR NODES
 %OPEN LIST FORMAT
 %--------------------------------------------------------------------------
 %IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
 %--------------------------------------------------------------------------
 %EXPANDED ARRAY FORMAT 扩展阵列格式
 %--------------------------------
 %|X val |Y val ||h(n) |g(n)|f(n)|
 %--------------------------------
 for i=1:exp_count         %%% 把exp_array内的元素添加到 开启列表 里面
    flag=0;                %%% 将exp_array内的点的标志位设为0
    for j=1:OPEN_COUNT         %%% OPEN_COUNT 从1开始，自加
        if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) )    %%%判断可选子节点是否与OPEN[]中的点相同
            OPEN(j,8)=min(OPEN(j,8),exp_array(i,5));                       %%%如果相同，比较两个fn的值的大小，并将fn小的坐标点赋值给OPEN(j,8)
            if OPEN(j,8)== exp_array(i,5)                                  %%% 表示，上一步比较中 exp_array(i,5)小，则把exp_array(i,：）中的值赋给OPEN
                %UPDATE PARENTS,gn,hn
                OPEN(j,4)=xNode;
                OPEN(j,5)=yNode;
                OPEN(j,6)=exp_array(i,3);
                OPEN(j,7)=exp_array(i,4);
            end;%End of minimum fn check
            flag=1;                    %%%将与ＯＰＥＮ相同的ｆｌａｇ＝０
        end;%End of node check
%         if flag == 1
%             break;
    end;%End of j for
    if flag == 0
        OPEN_COUNT = OPEN_COUNT+1; 
        OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),xNode,yNode,exp_array(i,3),exp_array(i,4),exp_array(i,5));
     end;%End of insert new element into the OPEN list
 end;%End of i for
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %END OF WHILE LOOP
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %Find out the node with the smallest fn  找出fn最小的节点
  index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget);   %%%选出fn最小那一行，将行数赋给 index_min_node
  if (index_min_node ~= -1)    
   %Set xNode and yNode to the node with minimum fn 将xNode和yNode设置为最小fn的节点
   xNode=OPEN(index_min_node,2);
   yNode=OPEN(index_min_node,3);
   path_cost=OPEN(index_min_node,6);% Update the cost of reaching the parent node 更新到达父节点的成本  gn
  %Move the Node to list CLOSED   将节点移动到列表CLOSED  
  CLOSED_COUNT=CLOSED_COUNT+1;
  CLOSED(CLOSED_COUNT,1)=xNode;
  CLOSED(CLOSED_COUNT,2)=yNode;
  OPEN(index_min_node,1)=0;
%   CLOSED  %%%****输出CLOSE[]，
%   OPEN    %%%****输出OPEN[]，
  else
      %No path exists to the Target!!
      NoPath=0;%Exits the loop!
  end;%End of index_min_node check
end;%End of While Loop
%Once algorithm has run The optimal path is generated by starting of at the
%last node(if it is the target node) and then identifying its parent node
%until it reaches the start node.This is the optimal path

i=size(CLOSED,1);
Optimal_path=[];
xval=CLOSED(i,1);
yval=CLOSED(i,2);
i=1;
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
i=i+1;

if ( (xval == xTarget) && (yval == yTarget))
    
   parent_x=OPEN(node_index(OPEN,xval,yval),4);%node_index returns the index of the node
   parent_y=OPEN(node_index(OPEN,xval,yval),5);
   
   while( parent_x ~= xStart || parent_y ~= yStart)
           Optimal_path(i,1) = parent_x;
           Optimal_path(i,2) = parent_y;
           %Get the grandparents:-)
           inode=node_index(OPEN,parent_x,parent_y);
           parent_x=OPEN(inode,4);%node_index returns the index of the node
           parent_y=OPEN(inode,5);
           i=i+1;
    end;
 j = size(Optimal_path,1) + 1;
  Optimal_path(j,1) = xStart;           
  Optimal_path(j,2) = yStart; %%%把起始点加进去
  
  NewOptimal_path=Optimal_path;
 disp('传统A*算法规划时间')
 toc
 j = size(NewOptimal_path,1) ;

 
angle_du=0;
 for i=1:1:(j-2)  %%%% 
     du=angle6(  NewOptimal_path(i,1),NewOptimal_path(i,2),NewOptimal_path(i+1,1) ,NewOptimal_path(i+1,2),NewOptimal_path(i+2,1) ,NewOptimal_path(i+2,2));
     angle_du=angle_du+du;
     
 end
 disp('传统A*算法转折度数')
 angle_du
 disp('传统A*算法转折次数')
 ci=angle_du/45
 S=0;
 for i=1:1:(j-1)  %%%% 求路径所用的实际长度
     Dist=sqrt( ( NewOptimal_path(i,1) - NewOptimal_path(i+1,1) )^2 + ( NewOptimal_path(i,2) - NewOptimal_path(i+1,2))^2);
     S=S+Dist;
     
 end
disp('传统A*算法路径长度')
 S 
  disp('传统A*算法遍历节点数')
  op_size=size(OPEN,1)

if hui==1  
  for n=1:op_size
     i=OPEN(n,2);
     j=OPEN(n,3);
     fill([i,i+1,i+1,i],[j,j,j+1,j+1],[0.85 0.85 0.85]);
 end
end 
plot(xTarget+0.5,yTarget+0.5,'go');
plot(xStart+0.5,yStart+0.5,'b^');
plot(Optimal_path(:,1)+.5,Optimal_path(:,2)+.5,'b','linewidth',2); %5%绘线
xlabel('基于A*算法的路径规划 ','Color','black'); 
else
 pause(1);
 h=msgbox('Sorry, No path exists to the Target!','warn');
 uiwait(h,5);
end

    





