if !exists('g:SavedColorSchemeDirectory')
    let g:SavedColorSchemeDirectory = expand('~/.vim/colorschemes')
endif

if !exists('g:UseSavedColorScheme')
    let g:UseSavedColorScheme = 1
endif

if !exists('g:ColorSchemeAutoCompile')
    let g:ColorSchemeAutoCompile = 0
endif

if exists('g:ColorSchemeAutoCompile')
    autocmd ColorScheme * call CompileCurrentColorScheme(0)
endif

function! s:EnsureDirectory(path)

    let Expanded = expand(a:path)
    if isdirectory(Expanded)
        return 1
    endif

    return mkdir(Expanded, "p")

endfunction

function! SaveCurrentColorScheme(overwrite)
	if exists('g:colors_name')

            call s:EnsureDirectory(g:SavedColorSchemeDirectory)
            if !isdirectory(g:SavedColorSchemeDirectory)
                echoerr "Failed to create directory: '" . g:SavedColorSchemeDirectory . "'"
                return 0
            endif

            let OutputPath = join([g:SavedColorSchemeDirectory, g:colors_name . '.vim'], '/')
            if !a:overwrite && filereadable(OutputPath)
                return 0
            endif

            if filereadable(OutputPath)
                call delete(OutputPath)
            endif

            redir >> OutputPath
            highlight
            redir end

            return 1

	endif
endfunction
command! -nargs=0 SaveCurrentColorScheme call SaveCurrentColorScheme(1)

function! LoadColorScheme(name)

    if exists('g:UseSavedColorScheme') && g:UseSavedColorScheme

        let Path = join([g:SavedColorSchemeDirectory, a:name . '.vim'], '/')
        if filereadable(Path)
            execute "source " . Path
            return 1
        endif
    endif

    execute "colorscheme " . a:name
    return 1

endfunction
command! -nargs=* -complete=color LoadColorScheme call LoadColorScheme(<q-args>)

