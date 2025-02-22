clc;
clear;
load("MatrixB.mat");

[m, n] = size(B);
Q = eye(m);

for k = 1 : n
    y = B(k : m, k);
    y1 = y(1, 1);
    e1 = zeros(m - k + 1, 1);
    e1(1, 1) = 1;
    w = y + sign(y1) * norm(y) * e1;
    v_k = w / norm(w);
    H = eye(m);
    H(k:m, k:m) = H(k:m, k:m) - 2 * v_k * v_k';
    B(k : m, k : n) = B(k : m, k : n) - 2 * v_k * (v_k' * B(k : m, k : n));
    Q = Q * H;
end
R = B;

R = inv(R);
Q = Q';
B_my = R * Q;

load("MatrixB.mat")
B = inv(B);

eps = 1e-10;
[m, n] = size(B);
st = 1;
for i = 1:m
    for j = 1:n
        if abs(B(i, j) - B_my(i, j)) > eps
            st = 0;
            break;
        end
    end
    if st == 0
        break;
    end
end
if B ~= B_my
    disp("QR求解错误");
else
    disp("矩阵B的逆矩阵：");
    disp(B_my);
    disp("QR求解正确");
end