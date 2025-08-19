# shellcheck shell=sh disable=SC2034

Describe "dye_detect"
	Include "./dye.sh"

	Parameters
	#	tput	tty	NO_COLOR	CLICOLOR_FORCE	CLICOLOR	default		result
		present	yes	""		""		""		""		success
		present	yes	""		""		""		default-off	failure
		present	yes	set		""		""		""		failure
		present	yes	set		""		""		default-off	failure
		present	yes	""		set		""		""		success
		present	yes	""		set		""		default-off	success
		present	yes	set		set		""		""		failure
		present	yes	set		set		""		default-off	failure
		present	yes	""		""		set		""		success
		present	yes	""		""		set		default-off	success
		present	yes	set		""		set		""		failure
		present	yes	set		""		set		default-off	failure
		present	yes	""		set		set		""		success
		present	yes	""		set		set		default-off	success
		present	yes	set		set		set		""		failure
		present	yes	set		set		set		default-off	failure
		present	no	""		""		""		""		failure
		present	no	""		""		""		default-off	failure
		present	no	set		""		""		""		failure
		present	no	set		""		""		default-off	failure
		present	no	""		set		""		""		success
		present	no	""		set		""		default-off	success
		present	no	set		set		""		""		failure
		present	no	set		set		""		default-off	failure
		present	no	""		""		set		""		failure
		present	no	""		""		set		default-off	failure
		present	no	set		""		set		""		failure
		present	no	set		""		set		default-off	failure
		present	no	""		set		set		""		success
		present	no	""		set		set		default-off	success
		present	no	set		set		set		""		failure
		present	no	set		set		set		default-off	failure
		absent	yes	""		""		""		""		failure
		absent	yes	""		""		""		default-off	failure
		absent	yes	set		""		""		""		failure
		absent	yes	set		""		""		default-off	failure
		absent	yes	""		set		""		""		failure
		absent	yes	""		set		""		default-off	failure
		absent	yes	set		set		""		""		failure
		absent	yes	set		set		""		default-off	failure
		absent	yes	""		""		set		""		failure
		absent	yes	""		""		set		default-off	failure
		absent	yes	set		""		set		""		failure
		absent	yes	set		""		set		default-off	failure
		absent	yes	""		set		set		""		failure
		absent	yes	""		set		set		default-off	failure
		absent	yes	set		set		set		""		failure
		absent	yes	set		set		set		default-off	failure
		absent	no	""		""		""		""		failure
		absent	no	""		""		""		default-off	failure
		absent	no	set		""		""		""		failure
		absent	no	set		""		""		default-off	failure
		absent	no	""		set		""		""		failure
		absent	no	""		set		""		default-off	failure
		absent	no	set		set		""		""		failure
		absent	no	set		set		""		default-off	failure
		absent	no	""		""		set		""		failure
		absent	no	""		""		set		default-off	failure
		absent	no	set		""		set		""		failure
		absent	no	set		""		set		default-off	failure
		absent	no	""		set		set		""		failure
		absent	no	""		set		set		default-off	failure
		absent	no	set		set		set		""		failure
		absent	no	set		set		set		default-off	failure
	End

	Example "tput $1, tty $2, NO_COLOR=\"$3\", CLICOLOR_FORCE=\"$4\", CLICOLOR=\"$5\", \$1=\"$6\" → $7"
		if [ "$1" = "present" ]; then
			command() {
				[ "$1" = "-v" ] && [ "$2" = "tput" ] && echo "/usr/bin/tput" && return 0
				return 1
			}
		else
			command() {
				return 1
			}
		fi

		if [ "$2" = "yes" ]; then
			test()
			{
				[ "$1" = "-t" ] && [ "$2" = "1" ] && return 0
				# shellcheck disable=SC2244
				[ "$@" ]
			}
		else
			test()
			{
				[ "$1" = "-t" ] && [ "$2" = "1" ] && return 1
				# shellcheck disable=SC2244
				[ "$@" ]
			}
		fi

		unset NO_COLOR
		unset CLICOLOR_FORCE
		unset CLICOLOR
		test -n "$3" && NO_COLOR="$3"
		test -n "$4" && CLICOLOR_FORCE="$4"
		test -n "$5" && CLICOLOR="$5"

		if [ -n "$6" ]; then
			When call dye_detect "$6"
		else
			When call dye_detect
		fi

		The status should be "$7"
	End
End
