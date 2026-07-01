#!/bin/bash

# 定义 Git 仓库绝对路径
REPO_DIR="/sdcard/Download/wms"

# 定义输出文件（如果不指定绝对路径，将生成在执行脚本的当前目录下）
OUTPUT_FILE="all_wms.txt"

# 1. 计算总版本数并减去 3
count=$(( $(git -C "$REPO_DIR" rev-list --count HEAD) - 3 ))

# 2. 如果计算出的数量大于0，则进行遍历，存入 OUTPUT_FILE
if [ $count -gt 0 ]; then
  > "$OUTPUT_FILE"  # 清空或创建文件，防止历史数据干扰
  
  # --- 第一个循环 ---
  for i in $(git -C "$REPO_DIR" rev-list HEAD --max-count=$count); do
    echo "版本ID: $i" >> "$OUTPUT_FILE"
    # 修改点：将 %cd 改为 %ad，获取作者时间
    echo "时间: $(git -C "$REPO_DIR" show -s --format=%ad --date=format:'%Y-%m-%d %H:%M:%S' "$i")" >> "$OUTPUT_FILE"
    git -C "$REPO_DIR" show "$i":wms.txt >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
  done
  
  # --- 第二个循环 ---
  # --skip=$count 跳过前面已经处理的版本，--max-count=2 只取最后的2个
  for i in $(git -C "$REPO_DIR" rev-list HEAD --skip=$count --max-count=2); do
    echo "版本ID: $i" >> "$OUTPUT_FILE"
    # 修改点：将 %cd 改为 %ad，获取作者时间
    echo "时间: $(git -C "$REPO_DIR" show -s --format=%ad --date=format:'%Y-%m-%d %H:%M:%S' "$i")" >> "$OUTPUT_FILE"
    git -C "$REPO_DIR" show "$i":简易仓库系统.txt >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
  done
  
  echo "处理完成，结果已保存到 $(pwd)/$OUTPUT_FILE"
else
  echo "总版本数不超过3个，无法分割。"
fi
