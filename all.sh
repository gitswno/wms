#!/bin/bash

# 定义 Git 仓库绝对路径
REPO_DIR="/sdcard/Download/wms"

# 定义输出文件
OUTPUT_FILE="all_wms"

# 获取30天前的 Unix 时间戳
# 兼容 Linux/Termux 和 macOS
PAST_TIMESTAMP=$(date -d "30 days ago" +%s 2>/dev/null || date -v-30d +%s 2>/dev/null)

if [ -z "$PAST_TIMESTAMP" ]; then
  echo "无法计算30天前的时间戳，请检查系统的 date 命令。"
  exit 1
fi

echo "正在提取最近30天 (作者时间) 的提交..."

> "$OUTPUT_FILE"  # 清空或创建文件
found=0

# 遍历所有提交
for i in $(git -C "$REPO_DIR" rev-list HEAD); do
  # 获取当前 commit 的【作者时间】Unix 时间戳 (%at)
  commit_timestamp=$(git -C "$REPO_DIR" show -s --format=%at "$i")
  
  # 比较时间戳：如果当前提交的作者时间 >= 30天前的时间，则处理
  if [ "$commit_timestamp" -ge "$PAST_TIMESTAMP" ]; then
    found=1
    echo "版本ID: $i" >> "$OUTPUT_FILE"
    echo "时间: $(git -C "$REPO_DIR" show -s --format=%ad --date=format:'%Y-%m-%d %H:%M:%S' "$i")" >> "$OUTPUT_FILE"
    git -C "$REPO_DIR" show "$i":wms | sed 's/绿色天堂/和谐和谐/g; s/白粉/和谐/g' >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
    echo >> "$OUTPUT_FILE"
  else
    # 因为 git rev-list HEAD 默认是按拓扑顺序/时间倒序输出的，遇到超过30天的就停止循环
    # 注意：如果提交历史中有交叉或 rebase，为了防止漏掉，这里如果不放心可以去掉 break，但通常保留可以提速
    break
  fi
done

if [ $found -eq 1 ]; then
  echo "处理完成，结果已保存到 $(pwd)/$OUTPUT_FILE"
else
  echo "最近30天内没有新的提交，无需提取历史。"
fi
