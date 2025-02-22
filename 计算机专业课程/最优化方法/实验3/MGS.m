clc;
clear;
load("MatrixA.mat");

[m, n] = size(A);
Q = zeros(m, n);
R = zeros(n, n);

eps = 1e-11;
Q(:, 1) = A(:, 1) / norm(A(:, 1));
for k = 2: n
    for j = k : n
        A(:, j) = A(:, j) - A(:, j)' * Q(:, k - 1) * Q(:, k - 1);
    end
    q_hat = A(:, k);
    if q_hat < eps
        break;
    end
    R(k, k) = norm(q_hat);
    Q(:, k) = q_hat / R(k, k);
end

disp("矩阵Q：");
disp(Q(:, 1 : 3));
% disp("矩阵R：");
% disp(R);

count_stablity(Q);