function exp_array=expand_array6(node_x,node_y,hn,xTarget,yTarget,CLOSED,MAX_X,MAX_Y,Nobs,xStart,yStart)
  
%     P_Obs_all=Nobs/(MAX_X*MAX_Y);
%     n0=exp(P_Obs_all);%-P_tong +P_obs
    
    nobs=Nobs;
    nobsl=Nobs+1;
    exp_array=[];  ou=[];  
    exp_count=0;    out1=[];a1=1;  out2=[];b1=1;
    c2=size(CLOSED,1);%Number of elements in CLOSED including the zeros    %%% CLOSED中的元素数，包括零
    for k= 1:-1:-1                                                         %%% k = 1  0  -1
        for j= 1:-1:-1                                                     %%% j = 1  0  -1
            if (k~=j || k~=0)     %%% k ~=j 或者 k ~= 0 满足：（k,j）(1,1)(1,0(1,-1)(0,1)(0,-1)(-1,1)(-1,0)(-1,-1)  %The node itself is not its successor %%%节点本身不是它的继承者
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
                  

                  
                
                   if (flag == 1)   
                        exp_count=exp_count+1;
                       % t=angle6(p_xNode,p_yNode,node_x,node_y,s_x, s_y);
                        P_obsNT=Obs_array(s_x,s_y,xTarget,yTarget,CLOSED,Nobs);
                      %  P_obsSN=Obs_array(s_x,s_y,xStart,yStart,CLOSED,Nobs);
                       % n1SN=exp(P_obsSN);%exp(P_obsSN)exp(P_obsSN)
                        n1NT=exp(P_obsNT);
                        ou(exp_count,1) = s_x;
                        ou(exp_count,2) = s_y;
                        ou(exp_count,3) = hn+distance(node_x,node_y,s_x,s_y);%  gn                             ****
                        ou(exp_count,4) = distance(xTarget,yTarget,s_x,s_y);% hn
                        ou(exp_count,5) = ou(exp_count,3) +n1NT*ou(exp_count,4);
                       % ou(exp_count,5) = r1*ou(exp_count,3) + r2*ou(exp_count,4)+ ou(exp_count,4)*exp(dnt/dst);
                       % ou(exp_count,5) = ou(exp_count,3) + ou(exp_count,4);
                    end%Populate the exp_array list!!!
                    
                end% End of node within array bound
            end%End of if node is not its own successor loop
        end%End of j for loop
    end%End of k for loop    
%    ou  %%%****输出ou，A*算法的运算过程**** 
   
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
% exp_array  %%%****输出exp_array，A*算法的运算过程****  

