using ReferenceFrameRotations
using LinearAlgebra
#using Gnuplot

# 位置と速度から座標変換のための方向余弦行列を求める
function getDCM(v,r)
    e1 = v / norm(v, 2)
    e2 = - cross(r,v) / (norm(r,2) * norm(v,2))
    e3 = - r/ norm(r,2)
    C = inv_rotation(DCM([e1;e2;e3]))
    return C
end

function transform_coordinate(C, r)
    
    
end

"""
# 方向余弦行列を用いてベクトルを変換
v = [2.0,0.0,0.0]
r = [1.0,1.0,1.0]

x = 1:10
@gp x x.^2 "w l tit 'Parabola'"
save("test2.gp")

C = getDCM(v,r)
println(C)
"""