clc;
clear;
load("MatrixA.mat");

[m, n] = size(A);
Q = eye(m);

for k = 1 : n
    y = A(k : m, k);
    y1 = y(1, 1);
    e1 = zeros(m - k + 1, 1);
    e1(1, 1) = 1;
    w = y + sign(y1) * norm(y) * e1;
    v_k = w / norm(w);
    H = eye(m);
    H(k:m, k:m) = H(k:m, k:m) - 2 * v_k * v_k';
    A(k : m, k : n) = A(k : m, k : n) - 2 * v_k * (v_k' * A(k : m, k : n));
    Q = Q * H;
end
R = A;
% load("MatrixA.mat");
% [Q, R] = qr(A);
% disp(size(R));
% disp("矩阵Q：");
% disp(Q(:, 1 : 3));
% disp("矩阵R：");
% disp(R);

count_stablity(Q);