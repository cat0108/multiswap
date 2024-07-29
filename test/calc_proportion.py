import os

def parse_time(time_str):
    """将时间字符串转换为秒数"""
    h, m, s = map(float, time_str.split(':'))
    return h * 3600 + m * 60 + s

def calculate_proportion(prefix):
    folder_path = './averagetime'
    
    # 找到符合条件的文件
    swapfile_path = None
    rdma_path = None
    
    for file in os.listdir(folder_path):
        if file.startswith(prefix) and 'swapfile' in file:
            swapfile_path = os.path.join(folder_path, file)
        elif file.startswith(prefix) and 'rdma' in file:
            rdma_path = os.path.join(folder_path, file)
    
    if not swapfile_path or not rdma_path:
        print("未找到符合条件的文件")
        return
    
    # 读取文件内容
    with open(swapfile_path, 'r') as f:
        swapfile_times = [parse_time(line.strip().split(': ')[1]) for line in f.readlines()]
    
    with open(rdma_path, 'r') as f:
        rdma_times = [parse_time(line.strip().split(': ')[1]) for line in f.readlines()]
    
    # 计算性能提升比例
    proportions = [(swap - rdma) / swap * 100 for swap, rdma in zip(swapfile_times, rdma_times)]
    
    # 打印结果
    for i, proportion in enumerate(proportions, 1):
        print(f"第{i}个结果: {proportion:.2f}%")

if __name__ == "__main__":
    prefix = input("请输入命令: ")
    calculate_proportion(prefix)