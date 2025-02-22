clc;
clear;
load("MatrixA.mat");

[m, n] = size(A);
Q = zeros(m, n);
R = zeros(n, n);

eps = 1e-11;
for k = 1: n
    R(1:k - 1, k) = Q(:, 1:k - 1)' * A(:, k);
    q_hat = A(:, k) - Q(:, 1:k - 1) * R(1:k - 1, k);
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