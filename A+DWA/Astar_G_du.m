function [Path,distanceX,OPEN_num]= Astar_G_du(Obs_Closed,St,Ta,MAX_X,MAX_Y)

CLOSED = Obs_Closed;
xStart = St(1,1);      yStart = St(1,2); 
xTarget = Ta(1,1);    yTarget = Ta(1,2);

OPEN=[];
%CLOSED LIST STRUCTURE %%% 封闭的列表结构
Num_obs=size(Obs_Closed,1);
CLOSED_COUNT=size(CLOSED,1);   %%% CLOSED的行数，即障碍点的个数 
Nobs=CLOSED_COUNT;

xNode=xStart;      %%% =xStart
yNode=yStart;      %%% =yStart
OPEN_COUNT=1;    %%% OPEN_COUNT 开启列表的行数标志
path_cost=0;
goal_distance=distance(xNode,yNode,xTarget,yTarget);                                                                                    %%%  ***调用distance（）函数，求两坐标点之间的笛卡尔距离
% Sgoal=goal_distance;
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

 exp_array=expand_array6(xNode,yNode,path_cost,xTarget,yTarget,CLOSED,MAX_X,MAX_Y,Nobs,xStart,yStart);  %%% 不在关闭列表的子节点，（x,y,gn,hn,fn）,列数是个数
 exp_count=size(exp_array,1);  %%%  可选择的子节点个数
 
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
            flag=1;                    %%%将与ＯＰＥＮ相同的ｆｌａｇ＝1
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
  
%    p_xNode=OPEN(index_min_node,4);
%    p_yNode=OPEN(index_min_node,5);
   %Move the Node to list CLOSED   将节点移动到列表CLOSED  
  CLOSED_COUNT=CLOSED_COUNT+1;
  CLOSED(CLOSED_COUNT,1)=xNode;
  CLOSED(CLOSED_COUNT,2)=yNode;
  OPEN(index_min_node,1)=0;
%   CLOSED  %%%****输出CLOSE[]，用来学习了解A*算法的运算过程**** 
%   OPEN    %%%****输出OPEN[]，用来学习了解A*算法的运算过程**** 
  else
      %No path exists to the Target!!
      NoPath=0;%Exits the loop!
  end;%End of index_min_node check
end;%End of While Loop


i=size(CLOSED,1);    %%%CLOSE里面的长度
Optimal_path=[];     %%%路径数组
xval=CLOSED(i,1);    %%%把CLOSE最后一组数提出来，最后一组数为目标点
yval=CLOSED(i,2);
i=1;
Optimal_path(i,1)=xval; %%%把目标点的坐标赋给 路径数组的 第一组
Optimal_path(i,2)=yval;
            

if ( (xval == xTarget) && (yval == yTarget))  %%%检测CLOSE最后一组是否为目标点
 
   %Traverse OPEN and determine the parent nodes 遍历OPEN并确定父节点
   Target_ind=node_index(OPEN,xval,yval);
   parent_x=OPEN(Target_ind,4); %node_index returns the index of the node  node_index返回节点的索引
   parent_y=OPEN(Target_ind,5);%%% 将当前点的父节点提出来
   Optimal_path(i,3)=parent_x; 
   Optimal_path(i,4)=parent_y;
   
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 while( parent_x ~= xStart || parent_y ~= yStart)   %%% 判断父节点是否为起始点
           i=i+1; 
           Optimal_path(i,1) = parent_x;             %%% 不是 则将父节点送给路径数组
           Optimal_path(i,2) = parent_y;
          
           inode=node_index(OPEN,parent_x,parent_y); 
           
           Optimal_path(i,3) = OPEN(inode,4);
           Optimal_path(i,4) = OPEN(inode,5);
           parent_x=Optimal_path(i,3);
           parent_y=Optimal_path(i,4);
        
 end;
  Num_Opt=size(Optimal_path,1);
 
 %%%  优化折线
 Optimal_path_one=Line_OPEN_ST(Optimal_path,CLOSED,Num_obs,Num_Opt);
%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%   把路径提取出来  %%%%%%%%%%%%%%%%%%%%%
 Optimal_path_try=[1 1 1 1];
 Optimal_path=[1 1 ];%node_l=[1 1];
 i=1;q=1;
 x_g=Optimal_path_one(Num_Opt,3);y_g=Optimal_path_one(Num_Opt,4);
 
 Optimal_path_try(i,1)= Optimal_path_one(q,1);
 Optimal_path_try(i,2)= Optimal_path_one(q,2);
 Optimal_path_try(i,3)= Optimal_path_one(q,3);
 Optimal_path_try(i,4)= Optimal_path_one(q,4);
 
   while (Optimal_path_try(i,3)~=x_g || Optimal_path_try(i,4)~=y_g)
      i=i+1;
      q=Optimal_index(Optimal_path_one,Optimal_path_one(q,3),Optimal_path_one(q,4));
      
      Optimal_path_try(i,1)= Optimal_path_one(q,1);
      Optimal_path_try(i,2)= Optimal_path_one(q,2);
      Optimal_path_try(i,3)= Optimal_path_one(q,3);
      Optimal_path_try(i,4)= Optimal_path_one(q,4);
      
   end
 %%%%%%%%%%%%%%%     反过来排列路线节点      %%%%%%%%%%%%%%%%%%%%%

 n=size(Optimal_path_try,1);
   for i=1:1:n
       Optimal_path(i,1)=Optimal_path_try(n,3);
       Optimal_path(i,2)=Optimal_path_try(n,4);
%        Optimal_path(i,3)=Optimal_path_try(n,1);
%        Optimal_path(i,4)=Optimal_path_try(n,2);
       n=n-1;
   end
   num_op=size(Optimal_path,1)+1;
   Optimal_path(num_op,1)=Optimal_path_try(1,1);
   Optimal_path(num_op,2)=Optimal_path_try(1,2);
 %  plot(Optimal_path(:,1)+.5,Optimal_path(:,2)+.5,'linewidth',1); %5%绘线
% 二次折线优化
 
 Optimal_path_two=Line_OPEN_STtwo(Optimal_path,CLOSED,Num_obs,num_op);
 num_optwo=size(Optimal_path_two,1)+1;
 Optimal_path_two(num_optwo,1)=xStart;
 Optimal_path_two(num_optwo,2)=yStart;
 % plot(Optimal_path_two(:,1)+.5,Optimal_path_two(:,2)+.5,'linewidth',1); %5%绘线
 % 三次折线
  j=num_optwo;
 Optimal_path_two2=[xStart yStart];
 for i=1:1:num_optwo
     Optimal_path_two2(i,1)=Optimal_path_two(j,1);
     Optimal_path_two2(i,2)=Optimal_path_two(j,2);
     j=j-1;
 end
  Optimal_path_three=Line_OPEN_STtwo(Optimal_path_two2,CLOSED,Num_obs,num_optwo);
  num_opthree=size(Optimal_path_three,1)+1;
  Optimal_path_three(num_opthree,1)=xTarget;
  Optimal_path_three(num_opthree,2)=yTarget;
 % plot(Optimal_path_three(:,1)+.5,Optimal_path_three(:,2)+.5,'b','linewidth',2);
  L_obst=2;% 每隔2个取点
  Obst_d_d_line=Line_obst(Optimal_path_three,L_obst);
  
  num_opthree=size(Obst_d_d_line,1)+1;
  Obst_d_d_line(num_opthree,1)=xTarget;
  Obst_d_d_line(num_opthree,2)=yTarget;
  
  NewOptimal_path=Obst_d_d_line;
%  plot(NewOptimal_path(:,1)+.5,NewOptimal_path(:,2)+.5,'r','linewidth',2);
  
 
%  plot(NewOptimal_path(:,1)+.5,NewOptimal_path(:,2)+.5,'b','linewidth',2); %5%绘线 'b',,'b'
 
 
% Num_OPEN=size(OPEN,1) %%%% 遍历节点数
%  %Num_OPtimal=size(Optimal_path,1);  %%%% 实际路径节点数
%  Num_NewOptimal_path=size(NewOptimal_path,1);  %%%% 新的实际节点数
%  zhuan_num=Num_NewOptimal_path-2
  S=0;
 j = size(NewOptimal_path,1) ;
 for i=1:1:(j-1)  %%%% 求路径所用的实际长度
     Dist=sqrt( ( NewOptimal_path(i,1) - NewOptimal_path(i+1,1) )^2 + ( NewOptimal_path(i,2) - NewOptimal_path(i+1,2))^2);
     S=S+Dist;
 end
distanceX=S;
ia_size=size(NewOptimal_path,1);
Path=[ ];
for i=1:1:ia_size
   Path(i,1) = NewOptimal_path(i,1);
   Path(i,2) = NewOptimal_path(i,2);
end
OPEN_num=size(OPEN,1);   
%  angle_du=0;
%  for i=1:1:(j-2)  %%%% 求路径所用的角度
%      du=angle6(  NewOptimal_path(i,1),NewOptimal_path(i,2),NewOptimal_path(i+1,1) ,NewOptimal_path(i+1,2),NewOptimal_path(i+2,1) ,NewOptimal_path(i+2,2));
%      angle_du=angle_du+du;
%      
%  end
%  angle_du
%  S
%  T= angle_du/45 + S + zhuan_num

%   p=plot(Optimal_path(j,1)+.5,Optimal_path(j,2)+.5,'bo'); %%
%  j=j-1;
%  for i=j:-1:1
%   pause(.25);
%   set(p,'XData',Optimal_path(i,1)+.5,'YData',Optimal_path(i,2)+.5);
%  drawnow ;
%  end;
 
% plot(Newopt(:,1)+.5,Newopt(:,2)+.5,'linewidth',2); %5%绘线
 
 
else
 pause(1);
 h=msgbox('Sorry, No path exists to the Target!','warn');
 uiwait(h,5);
end

















