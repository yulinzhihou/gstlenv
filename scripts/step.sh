#!/usr/bin/env bash
# 设置字符编码，确保中文正常显示
# 尝试设置 locale，如果失败则静默处理（不显示警告）
# 使用命令块包裹并重定向所有错误输出，彻底屏蔽警告信息
{
    export LANG=C.UTF-8 2>/dev/null || export LANG=en_US.UTF-8 2>/dev/null || export LANG=POSIX 2>/dev/null || true
    export LC_ALL=C.UTF-8 2>/dev/null || export LC_ALL=en_US.UTF-8 2>/dev/null || export LC_ALL=POSIX 2>/dev/null || true
} 2>/dev/null
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gstlenv.git
# Date :  2021-02-01
# Notes:  gstlenv for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 分步调试命令，手动创建新窗口，step 1,step 2,step 3,step 4
# 引入全局参数
if [ -f /root/.gs/.env ]; then
    . /root/.gs/.env
fi
# 颜色代码
if [ -f ./color.sh ]; then
    . ${GS_PROJECT}/scripts/color.sh
else
    . /usr/local/bin/color
fi

RUN_SH_FILE="/home/tlbb/run.sh"
TLBB_SERVER_DIR="/home/tlbb/Server"

# 解析 run.sh 文件，提取启动命令
parse_run_sh() {
    local run_file="$1"
    local steps=()
    local current_cd=""
    local current_export=""
    
    if [ ! -f "$run_file" ]; then
        echo -e "${CRED}错误：找不到 run.sh 文件：${run_file}${CEND}" >&2
        return 1
    fi
    
    # 读取文件内容，按块处理
    while IFS= read -r line || [ -n "$line" ]; do
        # 去除行尾空格
        line=$(echo "$line" | sed 's/[[:space:]]*$//')
        
        # 跳过空行
        [[ -z "$line" ]] && continue
        
        # 跳过纯注释行
        if [[ "$line" =~ ^[[:space:]]*#+[[:space:]]*$ ]]; then
            continue
        fi
        
        # 排除 billing 相关命令
        if [[ "$line" =~ [Bb][Ii][Ll][Ll][Ii][Nn][Gg] ]]; then
            continue
        fi
        
        # 提取 cd 命令（保存供后续使用）
        if [[ "$line" =~ cd[[:space:]]+([^;&|>]+) ]]; then
            current_cd=$(echo "${BASH_REMATCH[1]}" | xargs)
            # 继续读取下一行，因为 cd 通常和启动命令分开
            continue
        fi
        
        # 提取 export 环境变量（保存供后续使用）
        if [[ "$line" =~ export[[:space:]]+([^;&|>]+) ]]; then
            current_export="export ${BASH_REMATCH[1]}"
            # 继续读取下一行
            continue
        fi
        
        # 查找启动命令：./程序名
        # 匹配 ./程序名 后面可能跟着参数、重定向等
        if [[ "$line" =~ \.\/([^[:space:]]+)([[:space:]]*.*)? ]]; then
            local prog_name="${BASH_REMATCH[1]}"
            local rest_line="${BASH_REMATCH[2]}"
            
            # 排除压缩包等非可执行文件
            if [[ "$prog_name" =~ \.(tar|gz|zip|rar|7z|bz2|xz)$ ]]; then
                continue
            fi
            
            # 排除非启动命令（如 shm clear, rm 等）
            if [[ "$prog_name" == "shm" ]] && [[ "$rest_line" =~ clear ]]; then
                continue
            fi
            
            # 去掉后台运行和重定向参数
            rest_line=$(echo "$rest_line" | sed 's/[[:space:]]*>[[:space:]]*\/dev\/null[[:space:]]*2>&1[[:space:]]*&[[:space:]]*$//')
            rest_line=$(echo "$rest_line" | sed 's/[[:space:]]*&[[:space:]]*$//')
            rest_line=$(echo "$rest_line" | xargs)
            
            # 构建完整命令
            local full_cmd=""
            local cmd_parts=()
            
            # 添加环境变量设置
            if [ -n "$current_export" ]; then
                cmd_parts+=("$current_export")
            fi
            
            # 添加 cd 命令
            if [ -n "$current_cd" ]; then
                cmd_parts+=("cd ${current_cd}")
            fi
            
            # 添加执行命令
            if [ -n "$rest_line" ] && [[ "$rest_line" != "start" ]]; then
                # 如果有参数且不是 start（shm start 需要保留）
                cmd_parts+=("./${prog_name} ${rest_line}")
            elif [[ "$prog_name" == "shm" ]] && [[ "$rest_line" == "start" ]]; then
                # shm start 需要保留
                cmd_parts+=("./${prog_name} ${rest_line}")
            else
                cmd_parts+=("./${prog_name}")
            fi
            
            # 组合命令
            full_cmd=$(IFS=' && '; echo "${cmd_parts[*]}")
            
            # 检查程序是否存在
            local prog_path=""
            if [ -n "$current_cd" ]; then
                prog_path="${current_cd}/${prog_name}"
            else
                prog_path="${TLBB_SERVER_DIR}/${prog_name}"
            fi
            
            # 验证文件存在或可执行（shm 是脚本，特殊处理）
            if [[ "$prog_name" == "shm" ]] || [ -f "$prog_path" ] || [ -x "$prog_path" ] 2>/dev/null; then
                # 去重检查
                local exists=0
                for existing in "${steps[@]}"; do
                    if [[ "$existing" == "$full_cmd" ]]; then
                        exists=1
        break
    fi
done
                
                if [ $exists -eq 0 ]; then
                    steps+=("$full_cmd")
                fi
            fi
            
            # 重置 export（每个启动命令后重置，但保留 cd 供后续命令使用）
            # 注意：cd 可能被多个连续的命令共享（如 Login、CenterServer 等）
            current_export=""
        fi
    done < "$run_file"
    
    # 输出步骤数组
    if [ ${#steps[@]} -gt 0 ]; then
        printf '%s\n' "${steps[@]}"
    fi
}

# 执行 billing 启动（固定第一步）
run_billing() {
    if [ ! -d "/home/billing" ]; then
        echo -e "${CWARNING}未找到 billing 目录，跳过 billing 启动${CEND}"
        return 0
    fi
    
    cd /home/billing
    ./billing stop 2>/dev/null
    ./billing up -d
    if [ $? -eq 0 ]; then
        echo -e "${CSUCCESS}启动 [BILLING] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
        return 0
    else
        echo -e "${CRED}启动 [BILLING] 服务失败！${CEND}"
        return 1
    fi
}

# 执行从 run.sh 解析出的命令
run_step_from_runsh() {
    local step_num=$1
    local cmd="$2"
    local step_name="$3"
    
    echo -e "${CYELLOW}正在执行步骤 ${step_num}：${step_name}${CEND}"
    echo -e "${CYELLOW}执行命令：${cmd}${CEND}"
    echo ""
    
    # 执行命令（不使用后台运行，保持在前台以便调试）
    eval "$cmd"
    local result=$?
    
    if [ $result -eq 0 ]; then
        echo -e "${CSUCCESS}启动 [${step_name}] 服务成功，请耐心等待几分钟。建议使用：【runtop】查看情况！！${CEND}"
        return 0
    else
        echo -e "${CRED}启动 [${step_name}] 服务失败！${CEND}"
        return 1
    fi
}

# 获取步骤名称（从命令中提取）
get_step_name() {
    local cmd="$1"
    # 从命令中提取程序名
    if [[ "$cmd" =~ \.\/([^[:space:]&]+) ]]; then
        local prog_name="${BASH_REMATCH[1]}"
        # 处理 shm start 的情况
        if [[ "$prog_name" == "shm" ]]; then
            echo "ShareMemory"
        else
            echo "$prog_name"
        fi
    else
        echo "Unknown"
    fi
}

# 主函数
main() {
    if [ ! -d "/home/tlbb" ]; then
        echo -e "${CRED}请进入容器里面使用此命令，link 命令可以进入！${CEND}"
        echo -e "${CRED}使用此命令需要手动创建多窗口，点当前窗口标签右键---克隆/复制窗口---会基于当前窗口创建一个全新的窗口。每个窗口输入一个命令，一共需要多个窗口${CEND}"
        echo -e "${GSISSUE}\r\n"
        exit 1
    fi

    # 解析 run.sh 文件
    echo -e "${CYELLOW}正在解析 run.sh 文件...${CEND}"
    local steps=()
    while IFS= read -r line; do
        [ -n "$line" ] && steps+=("$line")
    done < <(parse_run_sh "$RUN_SH_FILE")
    
    if [ ${#steps[@]} -eq 0 ]; then
        echo -e "${CRED}错误：无法从 run.sh 中解析出启动命令！${CEND}"
        exit 1
    fi

    # 检查是否有 billing
    local has_billing=0
    if [ -d "/home/billing" ]; then
        has_billing=1
    fi
    
    # 如果提供了参数，直接执行
    if [ $# -eq 1 ]; then
        local step_num=$1
        
        # 处理第一步 billing
        if [ $step_num -eq 1 ] || [[ "$step_num" =~ ^[Bb] ]]; then
            if [ $has_billing -eq 1 ]; then
                run_billing
                exit $?
            else
                echo -e "${CWARNING}未找到 billing 服务，跳过第一步${CEND}"
                exit 0
            fi
        fi
        
        # 处理从 run.sh 解析出的步骤
        local actual_step=$step_num
        if [ $has_billing -eq 1 ]; then
            actual_step=$((step_num - 1))
        fi
        
        if [ $actual_step -ge 1 ] && [ $actual_step -le ${#steps[@]} ]; then
            local cmd="${steps[$((actual_step - 1))]}"
            local step_name=$(get_step_name "$cmd")
            run_step_from_runsh "$step_num" "$cmd" "$step_name"
            exit $?
        else
            echo -e "${CRED}错误：步骤编号 ${step_num} 无效！有效范围：1-$((has_billing + ${#steps[@]}))${CEND}"
            exit 1
        fi
    else
        # 交互式选择
        echo -e "${CRED}注意：执行此命令前，建议重启服务器，避免一些不必要的问题！${CEND}"
        echo -e "${CYELLOW}使用此命令需要手动创建多窗口，点当前容器标签右键---克隆/复制容器---会基于当前容器创建一个全新的容器。每个容器输入一个命令，一共需要 $((has_billing + ${#steps[@]})) 个窗口${CEND}"
        echo -e "${GSISSUE}\r\n"
        
        while :; do
            echo
            echo -e "${CYELLOW}※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※${CEND}"
            echo -e "${CYELLOW}◎ 请在容器外使用runtop命令查看开启了哪些进程${CEND}"
            echo -e "${CYELLOW}◎ 请不要重复启动，重复启动没有任何意义，也达到启动不了的效果。${CEND}"
            echo -e "${CYELLOW}◎ 使用 exit 退出容器操作命令行，使用 link 进入容器操作命令行${CEND}"
            echo ""
            
            local step_index=1
            # 显示 billing 步骤
            if [ $has_billing -eq 1 ]; then
                echo -e "${CYELLOW}◎ 步骤[${step_index}|b|billing|B|BILLING]：启动 [BILLING] 服务${CEND}"
                step_index=$((step_index + 1))
            fi
            
            # 显示从 run.sh 解析出的步骤
            for i in "${!steps[@]}"; do
                local cmd="${steps[$i]}"
                local step_name=$(get_step_name "$cmd")
                echo -e "${CYELLOW}◎ 步骤[${step_index}]：启动 [${step_name}] 服务${CEND}"
                echo -e "${CCYAN}   命令：${cmd}${CEND}"
                step_index=$((step_index + 1))
            done
            
            echo -e "${CYELLOW}※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※※${CEND}"
            echo ""
            read -e -p "${CYELLOW}请选择功能 输入序号并回车：${CEND} " num
            
            # 处理 billing
            if [[ "$num" =~ ^[Bb] ]] || [ "$num" == "1" ] && [ $has_billing -eq 1 ]; then
                run_billing
                break
            fi
            
            # 处理数字输入
            if [[ "$num" =~ ^[0-9]+$ ]]; then
                local actual_step=$num
                if [ $has_billing -eq 1 ]; then
                    actual_step=$((num - 1))
                fi
                
                if [ $actual_step -ge 1 ] && [ $actual_step -le ${#steps[@]} ]; then
                    local cmd="${steps[$((actual_step - 1))]}"
                    local step_name=$(get_step_name "$cmd")
                    run_step_from_runsh "$num" "$cmd" "$step_name"
                break
                else
                    echo -e "${CRED}输入错误！请输入有效的步骤编号！${CEND}"
                fi
            else
                echo -e "${CRED}输入错误！请输入数字或 b/billing！${CEND}"
            fi
        done
    fi
}

# 执行主函数
main "$@"
