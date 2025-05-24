function i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget)
%Function to return the Node with minimum fn
% This function takes the list OPEN as its input and returns the index of the
% node that has the least cost
%
%   Copyright 2009-2010 The MathWorks, Inc.

 temp_array=[];
 k=1;
 flag=0;
 goal_index=0;
 for j=1:OPEN_COUNT
     if (OPEN(j,1)==1)
         temp_array(k,:)=[OPEN(j,:) j];             %#ok<*AGROW>
         if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget)
             flag=1;
             goal_index=j;                         %Store the index of the goal node 存储目标节点的索引
         end;
         k=k+1;
     end;
 end;                        %Get all nodes that are on the list open 获取列表中的所有节点
 if flag == 1               % one of the successors is the goal node so send this node 其中一个后继者是目标节点，因此发送此节点
     i_min=goal_index;
 end
 %Send the index of the smallest node 发送最小节点的索引
 if size(temp_array ~= 0)
%      temp_array  %%%****输出temp_array，A*算法的运算过程****  
     [min_fn,temp_min]=min(temp_array(:,8));%Index of the smallest node in temp array 临时数组中最小节点的索引
                                         %%%最小值赋给min_fn，最小值所在的行数赋给temp_min；    比如  A=[1 2 3;4 5 6;7 8 9;0 0 0] [a,b]=min(A(:,3)) a=0 b=4;
  i_min=temp_array(temp_min,9);          %Index of the smallest node in the OPEN array OPEN数组中最小节点的索引
 else
     i_min=-1;%The temp_array is empty i.e No more paths are available.  temp_array是空的，即没有更多的路径可用
 end;