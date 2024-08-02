# ~/.julia/config/startup.jl

push!(LOAD_PATH, pwd())

function _my_colorscheme()
	cs = SyntaxHighlighter.ColorScheme()
	SyntaxHighlighter.symbol!(cs, Crayon(foreground = :blue))
	SyntaxHighlighter.comment!(cs, Crayon(foreground = :light_gray))
	SyntaxHighlighter.string!(cs, Crayon(foreground = :cyan))
	# SyntaxHighlighter.call!(cs, Crayon(foreground = :light_cyan))
	SyntaxHighlighter.op!(cs, Crayon(foreground = :green))
	SyntaxHighlighter.keyword!(cs, Crayon(foreground = :green))
	# SyntaxHighlighter.text!(cs, Crayon(foreground = :default))
	SyntaxHighlighter.macro!(cs, Crayon(foreground = :light_red))
	SyntaxHighlighter.function_def!(cs, Crayon(foreground = :blue))
	SyntaxHighlighter.error!(cs, Crayon(foreground = :red, bold=true))
	SyntaxHighlighter.argdef!(cs, Crayon(foreground = :yellow))
	SyntaxHighlighter.number!(cs, Crayon(foreground = :cyan))
	return cs
end

atreplinit() do repl
	@eval using Revise
	@eval using OhMyREPL
	@eval using Crayons
	@eval import OhMyREPL: Passes.SyntaxHighlighter

	@eval SyntaxHighlighter.add!("MyCustomScheme", _my_colorscheme())
	@eval colorscheme!("MyCustomScheme")

	ENV["EDITOR"] = "gvim"
end
