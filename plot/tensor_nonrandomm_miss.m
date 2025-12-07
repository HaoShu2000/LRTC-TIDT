
% 绘制三种非随机缺失模式的示意图

% 设置张量维度
T = 30;  % 时间维度
M = 8;   % 空间维度1
N = 6;   % 空间维度2
rho = 0.3; % 缺失率

% 创建图形窗口
figure('Position', [100, 100, 1400, 900]);

%% 模式1: 时间维度的连续缺失
fprintf('生成模式1: 时间维度连续缺失...\n');
mask1 = generate_pattern1_missing(T, M, N, rho);
plot_pattern(mask1, 1, '模式1: 时间维度连续缺失');

%% 模式2: 每个时间向量连续缺失一段
fprintf('生成模式2: 每个时间向量连续缺失...\n');
mask2 = generate_pattern2_missing(T, M, N, rho);
plot_pattern(mask2, 2, '模式2: 每个时间向量连续缺失');

%% 模式3: 块状缺失
fprintf('生成模式3: 块状缺失...\n');
mask3 = generate_pattern3_missing(T, M, N, rho, 2, 2);
plot_pattern(mask3, 3, '模式3: 块状缺失');

% 添加总体标题
sgtitle('张量三种非随机缺失模式示意图', 'FontSize', 16, 'FontWeight', 'bold');

% 显示统计信息
display_statistics(mask1, mask2, mask3, T, M, N, rho);


function mask = generate_pattern1_missing(T, M, N, rho)
% 模式1: 时间维度的连续缺失 (t-a, t, :, :) 缺失
mask = true(T, M, N);

% 计算需要缺失的时间点数量
num_missing_time = round(T * rho);

if num_missing_time > 0
    % 随机选择缺失段的起始位置
    max_start = T - num_missing_time + 1;
    start_time = randi(max_start);
    end_time = start_time + num_missing_time - 1;
    
    % 设置缺失时间段（所有空间位置都缺失）
    mask(start_time:end_time, :, :) = false;
    
    fprintf('  时间缺失段: [%d, %d]\n', start_time, end_time);
end
end

function mask = generate_pattern2_missing(T, M, N, rho)
% 模式2: 每个时间向量连续缺失一段
mask = true(T, M, N);

for j = 1:M
    for k = 1:N
        % 为每个向量生成连续缺失段
        num_missing = round(T * rho);
        
        if num_missing > 0 && num_missing < T
            max_start = T - num_missing + 1;
            start_pos = randi(max_start);
            end_pos = start_pos + num_missing - 1;
            
            mask(start_pos:end_pos, j, k) = false;
        elseif num_missing >= T
            mask(:, j, k) = false;
        end
    end
end
end

function mask = generate_pattern3_missing(T, M, N, rho, block_size_M, block_size_N)
% 模式3: 块状缺失
mask = true(T, M, N);

% 计算块数量
num_blocks_M = ceil(M / block_size_M);
num_blocks_N = ceil(N / block_size_N);

% 对每个块生成相同的缺失模式
for block_i = 1:num_blocks_M
    for block_j = 1:num_blocks_N
        % 计算当前块的位置范围
        start_M = (block_i - 1) * block_size_M + 1;
        end_M = min(block_i * block_size_M, M);
        start_N = (block_j - 1) * block_size_N + 1;
        end_N = min(block_j * block_size_N, N);
        
        % 为当前块生成一个时间向量的缺失模式
        num_missing = round(T * rho);
        if num_missing > 0 && num_missing < T
            max_start = T - num_missing + 1;
            start_pos = randi(max_start);
            end_pos = start_pos + num_missing - 1;
            
            block_pattern = true(T, 1);
            block_pattern(start_pos:end_pos) = false;
            
            % 应用到当前块的所有向量
            for j = start_M:end_M
                for k = start_N:end_N
                    mask(:, j, k) = block_pattern;
                end
            end
        end
    end
end
end

function plot_pattern(mask, pattern_num, pattern_name)
% 绘制单个缺失模式的子图

% 选择颜色映射
cmap = [1, 0.2, 0.2; 0.2, 0.6, 1]; % 红色表示缺失，蓝色表示观测

% 子图1: 第一个N切片
subplot(3, 4, (pattern_num-1)*4 + 1);
slice_data = squeeze(mask(:,:,1));
imagesc(slice_data);
title(sprintf('%s\n第一个N切片', pattern_name), 'FontSize', 12);
xlabel('M维度'); ylabel('T维度');
colormap(gca, cmap);
colorbar;
axis equal tight;

% 子图2: 第一个M切片
subplot(3, 4, (pattern_num-1)*4 + 2);
slice_data = squeeze(mask(:,1,:))';
imagesc(slice_data);
title(sprintf('%s\n第一个M切片', pattern_name), 'FontSize', 12);
xlabel('N维度'); ylabel('T维度');
colormap(gca, cmap);
colorbar;
axis equal tight;

% 子图3: 所有N维度的平均
subplot(3, 4, (pattern_num-1)*4 + 3);
mean_slice = mean(mask, 3);
imagesc(mean_slice);
title(sprintf('%s\n所有N维度平均', pattern_name), 'FontSize', 12);
xlabel('M维度'); ylabel('T维度');
colormap(gca, parula);
colorbar;
axis equal tight;

% 子图4: 示例时间向量
subplot(3, 4, (pattern_num-1)*4 + 4);
hold on;

% 选择几个示例向量显示
if pattern_num == 1
    % 模式1: 显示不同空间位置的时间向量
    sample_positions = [1,1; 4,1; 1,3; 4,3];
elseif pattern_num == 2
    % 模式2: 显示随机位置的时间向量
    sample_positions = [randi(M), randi(N); randi(M), randi(N); 
                       randi(M), randi(N); randi(M), randi(N)];
else
    % 模式3: 显示不同块的时间向量
    sample_positions = [1,1; 1,2; 3,1; 3,2];
end

colors = lines(4);
for i = 1:size(sample_positions, 1)
    j = sample_positions(i, 1);
    k = sample_positions(i, 2);
    time_vec = mask(:, j, k);
    
    % 绘制时间向量（将不同向量垂直偏移显示）
    y_offset = (i-1) * 0.3;
    plot(1:T, time_vec * 0.2 + y_offset, 'Color', colors(i,:), 'LineWidth', 2);
    
    % 标记缺失段
    missing_indices = find(~time_vec);
    if ~isempty(missing_indices)
        plot(missing_indices, zeros(size(missing_indices)) + y_offset + 0.1, ...
             's', 'Color', colors(i,:), 'MarkerSize', 4, 'MarkerFaceColor', colors(i,:));
    end
end

title(sprintf('%s\n示例时间向量', pattern_name), 'FontSize', 12);
xlabel('时间'); ylabel('向量（偏移显示）');
xlim([1, T]);
ylim([-0.1, 1.3]);
grid on;

% 添加图例
if pattern_num == 1
    legend('观测段', '缺失段', 'Location', 'southwest');
end
end

function display_statistics(mask1, mask2, mask3, T, M, N, rho)
% 显示统计信息

fprintf('\n=== 缺失模式统计信息 ===\n');
fprintf('张量维度: %d×%d×%d\n', T, M, N);
fprintf('目标缺失率: %.3f\n\n', rho);

masks = {mask1, mask2, mask3};
pattern_names = {'模式1', '模式2', '模式3'};

for i = 1:3
    mask = masks{i};
    
    % 计算总体缺失率
    total_elements = T * M * N;
    missing_elements = total_elements - sum(mask(:));
    overall_rho = missing_elements / total_elements;
    
    % 计算每个时间向量的平均缺失率
    vector_rhos = zeros(M, N);
    for j = 1:M
        for k = 1:N
            vector_rhos(j, k) = 1 - mean(mask(:, j, k));
        end
    end
    mean_vector_rho = mean(vector_rhos(:));
    std_vector_rho = std(vector_rhos(:));
    
    fprintf('%s:\n', pattern_names{i});
    fprintf('  总体缺失率: %.3f\n', overall_rho);
    fprintf('  时间向量平均缺失率: %.3f ± %.3f\n', mean_vector_rho, std_vector_rho);
    fprintf('  缺失元素: %d/%d\n\n', missing_elements, total_elements);
end
end

