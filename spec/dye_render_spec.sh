# shellcheck shell=sh

Describe "dye_render"
	Include "./dye.sh"

	Example "basic colored text"
		dye() {
			echo "dye $*" 
		}
		dye_puts() {
			echo "dye_puts $*" 
		}

		expected_output="$(
			%text
			#|dye red
			#|dye_puts R
			#|dye green
			#|dye_puts G
			#|dye blue
			#|dye_puts B
			#|dye reset
		)"

		When call dye_render "{{red}}R{{green}}G{{blue}}B{{reset}}"
		The output should equal "${expected_output}"
	End
End
