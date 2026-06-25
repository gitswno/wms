# 1. 计算总版本数并减去 2
count=$(( $(git rev-list --count HEAD) - 3 ))

# 2. 如果计算出的数量大于0，则进行遍历，存入 all_wms.txt
if [ $count -gt 0 ]; then
  > all_wms.txt  # 清空或创建 all_wms.txt 文件，防止历史数据干扰
  for i in $(git rev-list HEAD --max-count=$count); do
    git show "$i":wms.txt >> all_wms.txt
  done
  
  # --skip=$count 跳过前面已经处理的版本，--max-count=2 只取最后的2个
  for i in $(git rev-list HEAD --skip=$count --max-count=2); do
    git show "$i":简易仓库系统.txt >> all_wms.txt
  done
else
  echo "总版本数不超过2个，无法分割。"
fi
