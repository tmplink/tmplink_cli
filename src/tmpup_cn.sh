#!/bin/bash
#@title: tmpup_cn.sh
#@description: 上传文件到钛盘
#@ahthor: tmplink studio
#@version: 1
#@date: 2023-03-09

# 设置默认值
model=0
mrid=0

# 解析命令行参数
while getopts "m:r:" opt; do
    case $opt in
        m) model=$OPTARG ;;
        r) mrid=$OPTARG ;;
        \?) echo "无效选项: -$OPTARG" >&2 ;;
    esac
done

# 读取 token 的值
if [ -f /etc/tmplink_cli.cfg ]; then
    token=$(cat /etc/tmplink_cli.cfg)
else
    echo "/etc/tmplink_cli.cfg Token文件不存在"
    exit 1
fi

if [ "$token" == "0" ]; then
    echo "token 值为 0"
    exit 1
fi

# 获取屏幕尺寸并计算窗口大小（宽度和高度均为屏幕尺寸的 80%）
screen_size=$(stty size)
screen_rows=$(echo "$screen_size" | cut -d ' ' -f 1)
screen_cols=$(echo "$screen_size" | cut -d ' ' -f 2)
window_rows=$((screen_rows * 8 / 10))
window_cols=$((screen_cols * 8 / 10))

# 扫描当前目录中的文件
files=()
while read -r file; do
    files+=("$file")
done <<< "$(find . -maxdepth 1 -type f | sort)"

# 构建 dialog 命令的参数列表
dialog_title="上传至钛盘"
if [ "$model" != "0" ] || [ "$mrid" != "0" ]; then
    dialog_title+=" (model: $model, dir: $mrid)"
fi


# 构建 dialog 命令的参数列表
args=("--stdout" "--separate-output" "--checklist" "$dialog_title" "$window_rows" "$window_cols" "${#files[@]}")
for i in "${!files[@]}"; do
    filename=$(basename "${files[$i]}")
    args+=("$((i+1))" "$filename" "off")
done

# 使用 dialog 创建选择界面
selected_files=$(dialog "${args[@]}")

# 检查用户是否选择了文件
if [ -n "$selected_files" ]; then
    # 处理文件名中包含空格和特殊字符的情况
    while read -r selected_file; do
        selected_file="${files[$((selected_file-1))]}"
        echo "正在上传 $selected_file"
        curl -k -F "file=@\"$selected_file\"" -F "token=$token" -F "model=$model" -F "mrid=$mrid" -X POST "https://connect.tmp.link/api_v2/cli_uploader"
    done <<< "$selected_files"
else
    echo "未选择任何文件"
fi
