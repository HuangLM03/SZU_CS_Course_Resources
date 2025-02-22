function x = Gauss2forSolution1(A, b)
    disp("高斯列主消元法")
    %% 预处理
    disp("预处理中...");
    [~, col_b] = size(b);
    if col_b == 1
        b = b';
    end
    [row_A, col_A] = size(A);
    [row_b, col_b] = size(b);
    AM = cat(2, A, b');
    [row_AM, col_AM] = size(AM);
    disp("预处理完成...");
    %% 求解
    disp("求解中...");
    if rank(A) ~= rank(AM)
        disp("无解");
    else 
        for i = 1 : row_AM
            [~, idx] = max(abs(AM(i : row_AM, i)));
            idx = idx + i - 1;
            AM([i, idx],:) = AM([idx, i], :);
        
            AM(i, :) = AM(i, :) ./ AM(i, i);
            for j = 1 : row_AM
                if j ~= i
                    AM(j, :) = AM(j, :) - AM(j, i) .* AM(i, :);
                end
            end
        end
    end
    disp("求解结束...");
    %% 输出解
    disp("线性方程组的解为：");
    x = (AM(:, row_A + 1))';
    disp(x);
    %% 验证解的准确性
    dev_b = (A * AM(:, row_A + 1))';
    exp = 1e-4;
    fail = false;
    for i = 1 : row_b
        for j = 1 : col_b
            if abs(dev_b(i, j) - b(i, j)) > exp
                fail = true;
                break;
            end
        end
        if fail == true
            break;
        end
    end
    %% 调用matlab自带库函数
    real_x = linsolve(A, b')';
    disp("正确的解为：");
    disp(real_x);
    for i = 1 : 1 : length(real_x)
        if abs(x(1, i) - real_x(1, i)) > exp
            fail = true;
            break;
        end
    end

    %% 计算损失
    loss = 0.0;
    for i = 1 : row_b
        for j = 1 : col_b
           loss = loss + abs(dev_b(i, j) - b(i, j));
        end
    end
    disp("loss: " + loss);
    if ~fail
        disp("求解正确");
    else
        disp("求解错误");
    end
    
    return;
end