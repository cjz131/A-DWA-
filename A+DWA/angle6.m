% 辅助函数: 计算三点之间的角度（假设已在代码中定义）
function angle = angle6(x1, y1, x2, y2, x3, y3)
    % 计算向量
    v1 = [x2-x1, y2-y1];
    v2 = [x3-x2, y3-y2];
    
    % 计算点积
    dot_product = v1(1)*v2(1) + v1(2)*v2(2);
    
    % 计算叉积的z分量（用于判断旋转方向）
    cross_z = v1(1)*v2(2) - v1(2)*v2(1);
    
    % 计算角度
    cos_theta = dot_product / (norm(v1) * norm(v2));
    cos_theta = min(max(cos_theta, -1), 1); % 防止数值误差导致超出[-1,1]范围
    theta = acos(cos_theta);
    
    % 根据叉积的z分量确定角度方向
    if cross_z < 0
        theta = -theta;
    end
    
    angle = theta;
end