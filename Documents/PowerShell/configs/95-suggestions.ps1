# --------------------------------------------------
# 历史命令搜索与快捷键绑定 (by prefix)
# --------------------------------------------------
# 允许前缀搜索历史时，光标自动移动到命令最末尾！
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true

# 绑定 向上箭头 和 Ctrl+P
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+p -Function HistorySearchBackward

# 绑定 向下箭头 和 Ctrl+N
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+n -Function HistorySearchForward

# 开启基于历史记录的实时灰字预测
Set-PSReadLineOption -PredictionSource History

# 开启混合预测模式（历史记录 + 原生补全引擎）
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

# 定义一个高阶补全脚本块
$MenuCompleteAndMoveToEnd = {
    # 首先触发原生的网格菜单补全
    [Microsoft.PowerShell.PSConsoleReadLine]::MenuComplete()
    
    # 补全完成后，强制将光标移动到整行命令的绝对末尾
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}

# 将 Tab 键绑定到这个自定义的智能脚本块上
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock $MenuCompleteAndMoveToEnd

# 确保开启了工具提示和可视化菜单展示 (否则两次 tab 不会显示 menu)
Set-PSReadLineOption -ShowToolTips

# 灰字提示接受快捷键：绑定 Ctrl + Spacebar
Set-PSReadLineKeyHandler -Key "Ctrl+Spacebar" -Function AcceptSuggestion