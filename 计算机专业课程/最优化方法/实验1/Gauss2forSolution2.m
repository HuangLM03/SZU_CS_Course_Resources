function Gauss2forSolution2(A)
    disp("高斯消元法")
    %% 预处理
    [row_A, col_A] = size(A);
    I = eye(row_A);
    A_1 = [];
    for k = 1 : 1 : row_A
        b = I(:, k);
        b = b';
        AM = cat(2, A, b');
        [row_b, col_b] = size(b);
        [row_AM, col_AM] = size(AM);
        %% 求解
        disp("求解" + k + "组中...");
        if rank(A) ~= rank(AM)
            disp("无解");
            return; 
        end
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
        disp("求解结束" + k + "组结束...");
        A_1 = cat(2, A_1, AM(:, row_A + 1));
    end
    %% 输出结果
    disp("矩阵A的逆为：");
    disp(A_1);
    %% 验证解的正确性
    dev_I = A * A_1;
    exp = 1e-4;
    fail = false;
    for i = 1 : 1 : row_A
        for j = 1 : 1 : row_A
            if abs(I(i, j) - dev_I(i, j)) > exp
                fail = true;
                break;
            end
        end
        if fail == true
            break;
        end
    end
    
    %% 计算损失
    loss = 0.0;
    for i = 1 : 1 : row_A
        for j = 1 : 1 : row_A
            loss = loss + abs(I(i, j) - dev_I(i, j));
        end
    end
    disp("loss: " + loss);

    if ~fail
        disp("求解正确");
    else
        disp("求解错误");
    end
    return;
    return;
end