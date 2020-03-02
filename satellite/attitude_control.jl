include("../plot/plot_plots.jl")
include("../plot/plot_makie.jl")

using Dates
using Quaternions
using LinearAlgebra


"""
m = cross_matrix(v)

2つのベクトルの外積cross(a, v)のvを行列化し、v*aで外積を計算できるようにする

# Argments
 - `vector`：外積するベクトル

# Return
 - `matrix`：行列化したベクトル
"""
function cross_matrix(vector)
	matrix = zeros(3,3)
	matrix[1,1] = 0
	matrix[1,2] = vector[3]
	matrix[1,3] = -vector[2]
	matrix[2,1] = -vector[3]
	matrix[2,2] = 0
	matrix[2,3] = vector[1]
	matrix[3,1] = vector[2]
	matrix[3,2] = -vector[1]
	matrix[3,3] = 0
	return matrix
end


"""
t_req  = lyapunov_torque(sat_tar, sat_att, kp, kr, ω)

リアプノフ関数から目標姿勢までに必要なトルクを求める

# Argments
 - `sat_tar`：目標姿勢クォータニオン
 - `sat_att`：現在の衛星姿勢クォータニオン
 - `kp`：ポイントゲイン
 - `kr`：レートゲイン
 - `ω`：位置ベクトルの角速度

# Return
 - `t_req`：必要トルク
"""
function lyapunov_torque(sat_tar, sat_att, kp, kr, ω)
	q_e = zeros(3)
	q = zeros(3)
	q_t = zeros(3)
	q[1] = sat_att.v1
	q[2] = sat_att.v2
	q[3] = sat_att.v3
	q4 = sat_att.s
	q_t[1] = sat_tar.v1
	q_t[2] = sat_tar.v2
	q_t[3] = sat_tar.v3
	q4_t = sat_tar.s
	q_e = - q4*q + q4*q_t - cross(q,q_t)
	return kp*q_e - kr*ω
end


"""
m = B_dot()

B-dot法により
姿勢制御する際に必要な磁気モーメントを求める

# Argments
 - `B`：地磁気ベクトル@ECEF
 - `ω`：位置ベクトルの角速度
 - `I`：慣性テンソル

# Return
- `m`：必要磁気モーメント
"""
function B_dot(B, ω, I)

end


"""
m = cross_product()

cross_product法により
姿勢制御する際に必要な磁気モーメントを求める

# Argments
 - `sat_tar`：目標姿勢クォータニオン
 - `sat_att`：現在の衛星姿勢クォータニオン
 - `kp`：ポイントゲイン
 - `kr`：レートゲイン
 - `ω`：位置ベクトルの角速度
 - `B`：地磁気ベクトル@ECEF

# Return
 - `m`：必要磁気モーメント
"""
function cross_product(sat_tar, sat_att, kp, kr, ω, B)
	m = zeros(3)
	#必要トルクを求める
	t_req = lyapunov_torque(sat_tar, sat_att, kp, kr, ω)
	#必要磁気モーメントを求める
	m = -(cross(t_req, B/norm(B)))/(norm(B))
	return m
end


"""
m = pseudo_inverse()

擬似逆行列により
姿勢制御する際に必要な磁気モーメントを求める

# Argments
 - `sat_tar`：目標姿勢クォータニオン
 - `sat_att`：現在の衛星姿勢クォータニオン
 - `kp`：ポイントゲイン
 - `kr`：レートゲイン
 - `ω`：位置ベクトルの角速度
 - `B`：地磁気ベクトル@ECEF
 - `ω`：位置ベクトルの角速度

# Return
- `m`：必要磁気モーメント
"""
function pseudo_inverse(sat_tar, sat_att, kp, kr, ω, B)
	m = zeros(3,3)
	B_mat = zeros(3,3)
	B_mat = cross_matrix(B)
	#B_matの擬似逆行列
	B_pse = B'
	#必要トルクを求める
	t_req = lyapunov_torque(sat_tar, sat_att, kp, kr, ω)
	m = B_pse*t_req
end


"""
out_cur = attitude_control()

目標姿勢まで姿勢制御する

# Argments
 - `sat_att`：現在の衛星姿勢クォータニオン
 - `sat_tar`：目標姿勢クォータニオン
 - `ω`：位置ベクトルの角速度
 - `I`：慣性テンソル

# Return
- `out_cur`：加える電流値
"""
function attitude_control(sat_att, sat_tar, B, ω, I)
    
end



