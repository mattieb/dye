# shellcheck shell=sh disable=SC1003

Describe "dye_render"
	Include "./dye.sh"

	dye() {
		printf "![%s]" "$*"
	}
	dye_puts() {
		printf "%s" "$1"
	}

	Example "basic colored text"
		When call dye_render "{{red}}R{{green}}G{{blue}}B{{reset}}"
		The output should equal "![red]R![green]G![blue]B![reset]"
	End

	Example "text with escaped curly braces"
		When call dye_render '{{red}}\{{R}}{{green}}{\{G}}{{blue}}\\B{{reset}}}\'
		The output should equal '![red]{{R}}![green]{{G}}![blue]\B![reset]}\'
	End

	Example "leading and trailing text, multi-word commands"
		When call dye_render "templating is {{italic}}very{{end italic}} cool!"
		The output should equal "templating is ![italic]very![end italic] cool!"
	End
End
