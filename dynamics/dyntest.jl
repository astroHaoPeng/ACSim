include("dynamics.jl")
using Plots
using ReferenceFrameRotations
#dynamics.jlのテスト
#クォータニオンとRK法による回転運動のシミュレーションのテスト(振り子)

l=10 #振り子の長さ
m=10 #重りの重さ
d=1 #重りの直径

g=9.8*[0,0,-1] #重力加速度ベクトル
r0=l*[1,0,0] #振り子の初期位置ベクトル
#慣性テンソル
Ix=0.4m*(d^2)
Iy=0.4m*(d^2)+m*(l^2)
Iz=0.4m*(d^2)+m*(l^2)
I=
[Ix 00 00
;00 Iy 00
;00 00 Iz]


#トルクを求める関数
function torque(q::Quaternion,(r0,m,g)::Tuple{Vector,Number,Vector})
    r=vect(q*r0*conj(q))
    T= conj(q)*cross(r,m*g)*q
    return [T.q1,T.q2,T.q3]
end

#力学的エネルギーを求める関数
function energy(q::Quaternion,ω::Vector,(r0,m,g)::Tuple{Vector,Number,Vector})
    r=vect(q*r0*conj(q))
    ω=vect(conj(q)*ω*q)
    v=cross(r,ω)
    f=m*g
    E=0.5m*dot(v,v)+0.5dot(ω,[Ix 0 0;0 Ix 0;0 0 Ix]*ω),-dot(r,f)
    return E
end

#振り子のシミュレーション
q=Quaternion(1.0,0.0,0.0,0.0)
ω=[0.0,-0.05pi,0.05pi]
E=energy(q,ω,(r0,m,g))
a=[(q,ω,E)]

len=1000
dt=0.01
for i in 2:len
    q,ω=(a[i-1][1],a[i-1][2])
    T=torque(q,(r0,m,g))
    q,ω=dynamics(q,ω,T,I,dt)
    E=energy(q,ω,(r0,m,g))
    push!(a,(q,ω,E))
end

#結果から一列取り出す関数
function hndlres(a,len,k)
    b=[a[1][k]]
    for i in 2:len
        push!(b,a[i][k])
    end
    return b
end

q=hndlres(a,len,1)
ω=hndlres(a,len,2)
Ek=hndlres(hndlres(a,len,3),len,1) #運動エネルギー
Ep=hndlres(hndlres(a,len,3),len,2) #位置エネルギー
;