# shellcheck shell=sh

Describe "dye"
	Include "./dye.sh"

	# useful for all dye tests
	# shellcheck disable=SC2329
	tput() {
		test -n "${2-}" && printf "%s" "\e{$1;$2}" && return
		test -n "$1" -a "${2-unset}" = "unset" && printf "%s" "\e{$1}" && return
	}

	Describe "color"
		Parameters
		#	name		number
			black		0
			red		1
			green		2
			yellow		3
			blue		4
			magenta		5
			cyan		6
			white		7
			gray		8
			brightred	9
			brightgreen	10
			brightyellow	11
			brightblue	12
			brightmagenta	13
			brightcyan	14
			brightwhite	15
			brightgray	7
			brightbrightred	9 # treat many "bright"s as one to avoid infinite recursion
			55		55
		End

		DYE_COLORS=256

		Example "$1 without text does not reset"
			name="$1"
			number="$2"

			When call dye "${name}"
			The output should equal "\e{setaf;${number}}"
		End

		Example "fg $1 without text does not reset"
			name="$1"
			number="$2"

			When call dye fg "${name}"
			The output should equal "\e{setaf;${number}}"
		End

		Example "bg $1 without text does not reset"
			name="$1"
			number="$2"

			When call dye bg "${name}"
			The output should equal "\e{setab;${number}}"
		End

		Example "$1 with text reset after text"
			name="$1"
			number="$2"

			When call dye "${name}" "${name} text"
			The output should equal "\e{setaf;${number}}${name} text\e{sgr0}"
		End

		Example "fg $1 with text reset after text"
			name="$1"
			number="$2"

			When call dye "${name}" "${name} text"
			The output should equal "\e{setaf;${number}}${name} text\e{sgr0}"
		End

		Example "bg $1 with text reset after text"
			name="$1"
			number="$2"

			When call dye bg "${name}" "${name} text"
			The output should equal "\e{setab;${number}}${name} text\e{sgr0}"
		End
	End

	Describe "synthesized high color"
		Parameters
		#	name		number	bold
			black		0	""
			red		1	""
			green		2	""
			yellow		3	""
			blue		4	""
			magenta		5	""
			cyan		6	""
			white		7	""
			gray		0	bold
			brightred	1	bold
			brightgreen	2	bold
			brightyellow	3	bold
			brightblue	4	bold
			brightmagenta	5	bold
			brightcyan	6	bold
			brightwhite	7	bold
			brightgray	7	""
			55		55	""
		End

		DYE_COLORS=8

		Example "$1 without text does not reset, synthesizes"
			name="$1"
			number="$2"
			bold="$3"
			expect_bold=""
			if [ -n "${bold}" ]; then
				expect_bold="\e{bold}"
			fi

			When call dye "${name}"
			The output should equal "${expect_bold}\e{setaf;${number}}"
		End

		Example "fg $1 without text does not reset, synthesizes"
			name="$1"
			number="$2"
			bold="$3"
			expect_bold=""
			if [ -n "${bold}" ]; then
				expect_bold="\e{bold}"
			fi

			When call dye fg "${name}"
			The output should equal "${expect_bold}\e{setaf;${number}}"
		End

		Example "bg $1 without text does not reset, does not synthesize"
			name="$1"
			number="$2"

			When call dye bg "${name}"
			The output should equal "\e{setab;${number}}"
		End

		Example "$1 with text reset after text, synthesizes"
			name="$1"
			number="$2"
			bold="$3"
			expect_bold=""
			if [ -n "${bold}" ]; then
				expect_bold="\e{bold}"
			fi

			When call dye "${name}" "${name} text"
			The output should equal "${expect_bold}\e{setaf;${number}}${name} text\e{sgr0}"
		End

		Example "fg $1 with text reset after text, synthesizes"
			name="$1"
			number="$2"
			bold="$3"
			expect_bold=""
			if [ -n "${bold}" ]; then
				expect_bold="\e{bold}"
			fi

			When call dye "${name}" "${name} text"
			The output should equal "${expect_bold}\e{setaf;${number}}${name} text\e{sgr0}"
		End

		Example "bg $1 with text reset after text, does not synthesize"
			name="$1"
			number="$2"

			When call dye bg "${name}" "${name} text"
			The output should equal "\e{setab;${number}}${name} text\e{sgr0}"
		End	
	End

	Describe "invalid color"
		DYE_COLORS=256

		Example "x55 does not output anything and fails"
			When call dye x55
			The output should equal ""
			The status should be failure
		End

		Example "fg x55 does not output anything"
			When call dye fg x55
			The output should equal ""
			The status should be failure
		End

		Example "bg x55 does not output anything"
			When call dye bg x55
			The output should equal ""
			The status should be failure
		End
	End

	Describe "sgr0-resettable"
		Parameters
		#	name	cap
			dim	dim
			bold	bold
			reverse	rev
		End

		DYE_COLORS=256

		Example "$1 without text does not reset"
			name="$1"
			cap="$2"

			When call dye "${name}"
			The output should equal "\e{${cap}}"
		End

		Example "begin $1 without text does not reset"
			name="$1"
			cap="$2"

			When call dye begin "${name}"
			The output should equal "\e{${cap}}"
		End

		Example "$1 with text resets after text"
			name="$1"
			cap="$2"

			When call dye "${name}" "${name} text"
			The output should equal "\e{${cap}}${name} text\e{sgr0}"
		End
	End

	Describe "endable"
		Parameters
		#	name		begin	end
			italic		sitm	ritm
			i		sitm	ritm
			standout	smso	rmso
			so		smso	rmso
			underline	smul	rmul
			u		smul	rmul
			ul		smul	rmul
		End

		DYE_COLORS=256

		Example "$1 without text does not end"
			name="$1"
			begin="$2"

			When call dye "${name}"
			The output should equal "\e{${begin}}"
		End

		Example "begin $1 without text does not end"
			name="$1"
			begin="$2"

			When call dye begin "${name}"
			The output should equal "\e{${begin}}"
		End

		Example "end $1 ends"
			name="$1"
			end="$3"

			When call dye end "${name}"
			The output should equal "\e{${end}}"
		End

		Example "$1 with text ends after text"
			name="$1"
			begin="$2"
			end="$3"

			When call dye "${name}" "${name} text"
			The output should equal "\e{${begin}}${name} text\e{${end}}"
		End
	End

	Describe "invalid endable"
		Parameters
			dim
			bold
			reverse
			invalid
		End

		DYE_COLORS=256

		Example "end $1 does not output anything and fails"
			name="$1"

			When call dye end "${name}"
			The output should equal ""
			The status should be failure
		End
	End

	Example "reset"
		DYE_COLORS=256
		When call dye reset
		The output should equal "\e{sgr0}"
	End

	Example "text does not necessarily need to be quoted"
		DYE_COLORS=256
		When call dye underline we don\'t need quoting here
		The output should equal "\e{smul}we don't need quoting here\e{rmul}"
	End

	Describe "templated output"
		DYE_COLORS=256

		Example "print adds newlines"
			# shellcheck disable=SC2329
			run() {
				dye print "we needed {{bold}}templating{{reset}}"
				dye print "and didn't know it"
			}

			expected() {
				%text
				#|we needed \e{bold}templating\e{sgr0}
				#|and didn't know it
			}

			When call run
			# shellcheck disable=SC2312
			The output should equal "$(expected)"
		End

		Example "write doesn't use newlines"
			# shellcheck disable=SC2329
			run() {
				dye write "{{red}}these {{yellow}}words {{green}}stay "
				dye write "{{cyan}}on {{blue}}one {{magenta}}line"
			}

			When call run
			The output should equal "\e{setaf;1}these \e{setaf;3}words \e{setaf;2}stay \e{setaf;6}on \e{setaf;4}one \e{setaf;5}line"
		End

		Example "write won't run arbitrary code"
			hacked="$(mktemp -d)/hacked"
			run() {
				dye write "{{red ;touch ${hacked}}}r3dz0r"
			}

			Path hacked-ioc="${hacked}"
			When call run
			The output should equal "\e{setaf;1};touch ${hacked}\e{sgr0}r3dz0r"
			The path hacked-ioc should not be a file
		End
	End

	Describe "setup"
		Example "no arguments"
			# shellcheck disable=SC2329
			dye_detect() {
				args="$*"
				%preserve args
			}

			When call dye setup 
			The variable args should equal ""
		End

		Example "default-off"
			# shellcheck disable=SC2329
			dye_detect() {
				# shellcheck disable=SC2034
				args="$*"
				%preserve args
			}

			When call dye setup default-off
			The variable args should equal "default-off"
		End

		Example "sets DYE_COLORS if dye_detect succeeds"
			# shellcheck disable=SC2329
			dye_detect() {
				return 0
			}
			# shellcheck disable=SC2329
			tput() {
				[ "$1" = "colors" ] && echo 256
			}

			unset DYE_COLORS
			When call dye setup
			The variable DYE_COLORS should equal "256"
		End

		Example "leaves DYE_COLORS unset if dye_detect fails, does not query for colors"
			dye_detect() {
				return 1
			}
			# shellcheck disable=SC2329
			tput() {
				return 1
			}

			unset DYE_COLORS
			When call dye setup
			The variable DYE_COLORS should be undefined
		End
	End

	Describe "templates"
		DYE_COLORS=256

		Example "basic colored text"
			When call dye_render "{{red}}R{{green}}G{{blue}}B{{reset}}"
			The output should equal "\e{setaf;1}R\e{setaf;2}G\e{setaf;4}B\e{sgr0}"
		End

		Example "text with escaped curly braces"
			# shellcheck disable=SC1003
			When call dye_render '{{red}}\{{R}}{{green}}{\{G}}{{blue}}\\B{{reset}}}\'
			# shellcheck disable=SC1003
			The output should equal '\e{setaf;1}{{R}}\e{setaf;2}{{G}}\e{setaf;4}\B\e{sgr0}}\'
		End

		Example "leading and trailing text, multi-word commands"
			When call dye_render "templating is {{italic}}very{{end italic}} cool!"
			The output should equal "templating is \e{sitm}very\e{ritm} cool!"
		End
	End

	Describe "control sequencing"
		Example "only prints third argument if DYE_COLORS is unset"
			# shellcheck disable=SC2329
			tput() {
				# shellcheck disable=SC2034
				called=1
				%preserve called
			}

			unset DYE_COLORS
			When call dye red "red text"
			The variable called should be undefined
			The output should equal "red text"
		End

		Example "calls tput once if DYE_COLORS is set and no text is present"
			# shellcheck disable=SC2329
			tput() {
				# shellcheck disable=SC2034
				arg1="$1"
				# shellcheck disable=SC2034
				arg2="${2-}"
				%preserve arg1 arg2
			}

			DYE_COLORS=256
			When call dye red
			The variable arg1 should equal "setaf"
			The variable arg2 should equal "1"
		End

		Example "outputs start sequence, text, and end sequence if DYE_COLORS is set and text is present"
			tput() {
				test "$1" = "setaf" -a "${2-}" = "1" && printf "%s" "!RED!" && return 0
				test "$1" = "sgr0" && printf "%s" "!RESET!" && return 0
				return 1
			}

			# shellcheck disable=SC2034
			DYE_COLORS=256
			When call dye red "red text"
			The output should equal "!RED!red text!RESET!"
		End
	End
End
