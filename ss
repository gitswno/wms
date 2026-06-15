#!/data/data/com.termux/files/usr/bin/env python3
import sys
import re
import subprocess

def main():
    if len(sys.argv) < 2:
        print("用法: {} <keyword>".format(sys.argv[0]))
        print("示例: {} hello".format(sys.argv[0]))
        sys.exit(1)
    
    keyword = sys.argv[1]
    file_path = "/storage/emulated/0/Download/wms/wms.txt"
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except FileNotFoundError:
        print("错误: 找不到文件 {}".format(file_path))
        sys.exit(1)
    
    # 定义颜色
    RED = '\033[31m'
    GREEN = '\033[32m'
    WHITE = '\033[37m'
    NC = '\033[0m'  # No Color
    
    # 查找所有包含关键词的行
    for line_num, line in enumerate(lines, 1):
        if keyword in line:
            # 高亮关键词
            highlighted_line = line.replace(keyword, f"{RED}{keyword}{NC}")
            
            # 打印带颜色的行 - 只让行号显示为绿色
            print(f"【关键字行】 第 {GREEN}{line_num}{NC} 行: {highlighted_line}", end='')
            
            # 检查当前行自身是否包含英文冒号
            if ':' in line:
                print("  └─ 该行自身包含冒号，无需往上查找。")
            else:
                # 往前逐行搜索第一个冒号
                for i in range(line_num - 1, 0, -1):
                    if ':' in lines[i-1]:
                        # 找到了，打印冒号所在行 - 只让行号显示为绿色
                        print(f"【货号】 第 {GREEN}{i}{NC} 行: {lines[i-1]}", end='')
                        break
                else:
                    # 如果一直往前找都没找到冒号行，给个提示
                    print("  └─ 往前搜索到第1行，未发现包含冒号的行。")
            
            print("----------------------------------------")  # 分隔线

if __name__ == "__main__":
    main()

