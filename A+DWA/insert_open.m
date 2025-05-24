function new_row = insert_open(xval,yval,parent_xval,parent_yval,hn,gn,fn)
%Function to Populate the OPEN LIST           %%% 填充OPEN LIST的功能
%OPEN LIST FORMAT 开放列表格式
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%-------------------------------------------------------------------------
%
%  Copyright 2009-2010 The MathWorks, Inc.
new_row=[1,8];
new_row(1,1)=1;
new_row(1,2)=xval;
new_row(1,3)=yval;
new_row(1,4)=parent_xval;
new_row(1,5)=parent_yval;
new_row(1,6)=hn;
new_row(1,7)=gn;
new_row(1,8)=fn;

end