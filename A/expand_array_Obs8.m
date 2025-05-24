function exp_array=expand_array_Obs8(node_x,node_y,hn,xTarget,yTarget,CLOSED,MAX_X,MAX_Y,Nobs,P)
    %Function to return an expanded array           %%%函数返回展开数组
    %This function takes a node and returns the expanded list of successors,with the calculated fn values.   %%%此函数接受一个节点并返回扩展的继承者列表，其中包含计算出的fn值。
    %The criteria being none of the successors are on the CLOSED list.                                       %%%标准是没有继承者在封闭名单上。
    %
    %    Copyright 2009-2010 The MathWorks, Inc.
    
   %dst=distance(xTarget,yTarget,xStart,yStart);
   % Wu=Angle05(xTarget-node_x,yTarget-node_y);
%     r1=distance(xTarget,yTarget,node_x,node_y);
%     r2=distance(xStart,yStart,node_x,node_y);
%     R=distance(xTarget,yTarget,xStart,yStart);
   
    nobs=Nobs;
    nobsl=Nobs+1;
    exp_array=[];  ou=[];  
    exp_count=0;    out1=[];a1=1;  out2=[];b1=1;
    c2=size(CLOSED,1);%Number of elements in CLOSED including the zeros    %%% CLOSED中的元素数，包括零
    for k= 1:-1:-1                                                         %%% k = 1  0  -1
        for j= 1:-1:-1                                                     %%% j = 1  0  -1
           % if (k~=j || k~=0)     %%% k ~=j 或者 k ~= 0 满足：（k,j） (1,1)(1,0)(1,-1)(0,1)(0,-1)(-1,1)(-1,0)(-1,-1)  
%              Wf=0;
%             for num_wu=1:1:3
%                    wu_k=Wu(num_wu,1);
%                    wu_j=Wu(num_wu,2);
%                    if k==wu_k&&j==wu_j
%                        Wf=1;
%                    end
%             end
            if (k~=j || k~=0) %&& Wf==0 
                s_x = node_x+k;   %%% 当前节点周围一圈的8个子节点                
                s_y = node_y+j;  
                if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y))    %node within array bound   %%% 数组绑定中的节点，在坐标内
                    flag=1;        %%% flag 信号            
                    for c1=1:nobs
                        if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2))     %%% 判断8个子节点是否在CLOSE中
                            flag=0;     %%% 在关闭列表中是该坐标点的标志位为0
                            if(s_x==node_x && (s_y==(node_y + 1) || s_y==(node_y - 1) ))
                                 out1(a1,1)=s_x;
                                 out1(a1,2)=s_y;
                                  a1=a1+1;
                            elseif(s_y==node_y && (s_x==(node_x + 1) || s_x==(node_x - 1) ))
                                 out2(b1,1)=s_x;
                                 out2(b1,2)=s_y;
                                 b1=b1+1;
                             end; 
                        end;
                    end;  %End of for loop to check if a successor is on closed list. %%% for循环结束，检查后继是否在关闭列表中。
                  
                    for c3=nobsl:c2
                       if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2))     %%% 判断8个子节点是否在CLOSE中
                            flag=0;     %%% 在关闭列表中是该坐标点的标志位为0 
                       end
                   end;
%                    if P_obs==0
%                        n1=0;
%                    else
%                        n1=1;
%                    end
                  
                   if (flag == 1)   
                        exp_count=exp_count+1;
                       % t=angle6(p_xNode,p_yNode,node_x,node_y,s_x, s_y);
                        ou(exp_count,1) = s_x;
                        ou(exp_count,2) = s_y;
                        ou(exp_count,3) = hn+distance(node_x,node_y,s_x,s_y);%  gn                             ****
                        ou(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);% hn +n3*distanceM_2(xTarget,yTarget,s_x,s_y)n3*distanceM_2(xTarget,yTarget,s_x,s_y)
                       % ou(exp_count,5) = ou(exp_count,3);
                        %ou(exp_count,5) =n1SN* ou(exp_count,3) +n1NT*ou(exp_count,4)+ n0*distanceM_2(xTarget,yTarget,s_x,s_y) ;%+ (r1/R)*ou(exp_count,4)  P_tong*        (1+tan(P_obs))*ou(exp_count,4)
                        ou(exp_count,5) =ou(exp_count,3) +(1-P)*ou(exp_count,4);
                   end
                  
                end% End of node within array bound
            end%End of if node is not its own successor loop
        end%End of j for loop
    end%End of k for loop    
%    ou  %%%****输出ou，用来学习了解A*算法的运算过程****  ///不需要知道过程可注释掉///
   
   a2=size(out1,1);
   b2=size(out2,1);
   e = size(ou,1);
    if(a2~=0)
        for i=1:e
           for j=1:a2
            if((ou(i,1)==(out1(j,1)+1) || ou(i,1)==(out1(j,1)-1)) && ou(i,2)==out1(j,2))
                 ou(i,1)=0;
                 ou(i,2)=0;
            end
           end
        end
    end
    
    if(b2~=0)
        for i=1:e
           for j=1:b2
            if(ou(i,1)==out2(j,1) && (ou(i,2)==(out2(j,2)+1) || ou(i,2)==(out2(j,2)-1)))
                 ou(i,1)=0;
                 ou(i,2)=0; 
            end
           end
        end
    end
j=1;   
for i=1:e
    if(ou(i,1)~=0 && ou(i,2)~=0)
        exp_array(j,1) = ou(i,1);
        exp_array(j,2 )= ou(i,2);
        exp_array(j,3) = ou(i,3);
        exp_array(j,4) = ou(i,4);
        exp_array(j,5) = ou(i,5);
        j=j+1;
    end
    
end
% exp_array  %%%****输出exp_array，用来学习了解A*算法的运算过程****  ///不需要知道过程可注释掉///

