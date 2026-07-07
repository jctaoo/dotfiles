# fnm node
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# Configure fzf
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    $env:FZF_DEFAULT_OPTS = "--height 100% " + `
        "--color=fg:-1,bg:-1,hl:4:bold " + `
        "--color=fg+:5:bold,bg+:-1,hl+:5:reverse,pointer:5 " + `
        "--color=info:5,prompt:2,marker:1,spinner:5,header:5 " + `
        "--border=rounded"

    if (-not (Get-Module -ListAvailable -Name "PSFzf")) {
        Write-Warning "PSFzf module not found. Please install it using 'Install-Module -Name PSFzf'."
    }

    $env:FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude .node_modules'

    $env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
    $env:FZF_CTRL_T_OPTS = "--preview ""bat --style=numbers --theme=ansi --color=always {}"""

    $env:FZF_ALT_C_COMMAND = 'fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
    $env:FZF_ALT_C_OPTS = "--preview ""eza --tree --level=2 --color=always --icons=always {}"""

    Import-Module PSFzf
    Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
}
