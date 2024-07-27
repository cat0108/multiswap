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

    # 中间部分的限定名称
    middle_names = ['dram', 'swapfile', 'rdma']

    # 获取所有符合条件的文件
    files = [f for f in os.listdir(folder_path) if f.startswith(prefix) and f.endswith('result.txt') and any(name in f for name in middle_names)]

    # 预定义标记、线条样式和颜色
    style_dict = {
        'dram': {'marker': 'o', 'linestyle': '-', 'color': 'blue'},
        'swapfile': {'marker': 's', 'linestyle': '--', 'color': 'green'},
        'rdma': {'marker': 'D', 'linestyle': '-.', 'color': 'red'}
    }

    # 按照预定义顺序绘制图表
    plt.figure(figsize=(10, 6))

    all_performances = []

    for name in middle_names:
        for file in files:
            if name in file:
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
                
                # 保存所有性能数据以便计算最小值
                all_performances.extend(performances)
                
                # 横坐标标签
                x_labels = ['50%', '60%', '70%', '80%', '90%']
                x = range(len(x_labels))
                
                # 获取标记、线条样式和颜色
                marker = style_dict[name]['marker']
                linestyle = style_dict[name]['linestyle']
                color = style_dict[name]['color']
                
                # 替换图例名称
                label = file.replace(f'{prefix}_', '').replace('_result.txt', '').replace('rdma', 'single_node')
                
                plt.plot(x, performances, linestyle=linestyle, marker=marker, color=color, label=label, markersize=8)
                
    plt.xticks(x, x_labels, fontproperties=zh_font, fontsize=14)

    # 获取当前的y轴刻度并手动添加最小值的刻度
    yticks = plt.gca().get_yticks().tolist()
    min_performance = min(all_performances)
    yticks = [min_performance] + yticks if min_performance < yticks[0] else yticks
    plt.yticks(yticks, fontsize=14)
    
    plt.xlabel('Percentage', fontproperties=zh_font, fontsize=16)
    plt.ylabel('efficiency value (1/s)', fontproperties=zh_font, fontsize=16)
    plt.grid(True, linestyle='--')  # 将网格线改为虚线

    # 添加图例并放置在图表上方
    legend_font = fm.FontProperties(fname='/usr/share/fonts/truetype/wqy/wqy-microhei.ttc', size=18)  # 设置图例字体大小
    plt.legend(loc='upper center', bbox_to_anchor=(0.5, 1.15), ncol=len(files), prop=legend_font)

    # 调整图表布局以避免重叠
    plt.tight_layout(rect=[0, 0, 1, 0.95])

    # 保存图表为文件
    plt.savefig(f'./plot/{prefix}_plot_secondgroup.png')

    # 显示图表
    plt.show()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python plot_performance.py <prefix>")
    else:
        plot_performance(sys.argv[1])
