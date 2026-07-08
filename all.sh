#!/bin/bash

# 定义 Git 仓库绝对路径
REPO_DIR="/sdcard/Download/wms"

# 定义输出文件
OUTPUT_FILE="all_wms.txt"

count=$(( $(git -C "$REPO_DIR" rev-list --count HEAD)))

if [ $count -gt 0 ]; then
  > "$OUTPUT_FILE"  # 清空或创建文件
  
  # 只需要一个循环即可处理所有目标版本
  for i in $(git -C "$REPO_DIR" rev-list HEAD --max-count=$count); do
    echo "版本ID: $i" >> "$OUTPUT_FILE"
    echo "时间: $(git -C "$REPO_DIR" show -s --format=%ad --date=format:'%Y-%m-%d %H:%M:%S' "$i")" >> "$OUTPUT_FILE"
    git -C "$REPO_DIR" show "$i":wms.txt >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
  done
  
  echo "处理完成，结果已保存到 $(pwd)/$OUTPUT_FILE"
else
  echo "总版本数不超过1个，无需提取历史。"
fi
