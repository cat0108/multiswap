import matplotlib.pyplot as plt
from datetime import datetime, timedelta
import matplotlib.font_manager as fm
import os
import sys

def plot_performance(prefix):
    # 设置中文字体
    zh_font = fm.FontProperties(fname='/usr/share/fonts/truetype/wqy/wqy-microhei.ttc')

    # 文件夹路径
    folder_path = './averagetime'

    # 获取所有符合条件的文件
    files = [f for f in os.listdir(folder_path) if f.startswith(prefix) and f.endswith('result.txt')]

    # 不同的标记和线条样式
    markers = ['o', 's', 'D', '^', 'v', '<', '>', 'p', '*', 'h']
    linestyles = ['-', '--', '-.', ':']

    # 绘制图表
    plt.figure(figsize=(10, 6))

    for i, file in enumerate(files):
        file_path = os.path.join(folder_path, file)
        
        # 读取文件中的数据
        with open(file_path, 'r') as f:
            times_str = [line.strip().split(': ')[1] for line in f.readlines()]
        
        # 将时间字符串转换为timedelta对象
        times = [datetime.strptime(t, "%H:%M:%S.%f") - datetime(1900, 1, 1) for t in times_str]
        
        # 计算时间的倒数作为性能数据
        performances = [1 / t.total_seconds() for t in times]
        
        # 只取前五个点
        performances = performances[:5]
        
        # 横坐标标签
        x_labels = ['50%', '60%', '70%', '80%', '90%']
        x = range(len(x_labels))
        
        # 绘制曲线
        marker = markers[i % len(markers)]
        linestyle = linestyles[i % len(linestyles)]
        plt.plot(x, performances, linestyle=linestyle, marker=marker, label=file.replace(f'{prefix}_', '').replace('_result.txt', ''), markersize=8)
        
    plt.xticks(x, x_labels, fontproperties=zh_font)
    plt.xlabel('Percentage', fontproperties=zh_font)
    plt.ylabel('efficiency value (1/s)', fontproperties=zh_font)
    plt.grid(True, linestyle='--')  # 将网格线改为虚线

    # 添加图例并放置在图表上方
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.1), ncol=len(files), prop=zh_font)

    # 调整图表布局以避免重叠
    plt.tight_layout(rect=[0, 0, 1, 0.95])

    # 保存图表为文件
    plt.savefig(f'./plot/{prefix}_plot.png')

    # 显示图表
    plt.show()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python plot_performance.py <prefix>")
    else:
        plot_performance(sys.argv[1])