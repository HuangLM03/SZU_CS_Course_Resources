clc;
clear;
load("Matrix_A_b.mat");

% 精确解
[Q, R] = qr(A);
x_least = pinv(R) * Q' * b;
disp(x_least);
% 近似解
eps = 1e-3;
x_similar = zeros(40, 1);
for i = 1:2000
    f(1, i) = 0.5 * norm(A * x_similar - b, 2) ^ 2;
    p = A' * (A * x_similar - b);
    a = norm(p, 2) ^ 2 / norm(A * p, 2) ^ 2;
    tmp_x_similar = x_similar - a * p;
    temp(1, i) = norm((tmp_x_similar - x_similar), 2) / norm(x_similar, 2);
    error(1, i) = norm((x_similar - x_least), 2);

    if temp(1, i) < eps
        break
    end
    x_similar = tmp_x_similar;
end
plot(error);
set(gca, "XTick", [0:10:200]);
xlabel("迭代次数");
ylabel("误差");
