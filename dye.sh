# shellcheck shell=sh
#
# Copyright 2025, 2026 Mattie Behrens.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to one of the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

dye_detect() {
	command -v tput >/dev/null || return 1
	test -n "${NO_COLOR-}" && return 1
	test -n "${CLICOLOR_FORCE-}" && return
	test -t 1 || return 1
	test -n "${CLICOLOR-}" && return
	test "${1-}" = "default-off" && return 1
	return 0
}

dye_puts() {
	printf "%s" "$1"
}

dye_split() (
	read -r _1 _2 <<EOT
$2
EOT
	if [ -z "${_2-}" ]; then
		"$1" "${_1}"
	else
		"$1" "${_1}" "${_2}"
	fi
	return $?
)

dye_out() (
	_1="$1"
	_2="${2-}"
	test -n "$1" && shift
	test -n "${1-}" && shift
	if [ -z "${DYE_COLORS-}" ]; then
		dye_puts "$*"
		return
	fi
	if [ -z "${_2}" ] || [ -z "${1-}" ]; then
		dye_split tput "${_1}" || true
		return
	fi
	dye_split tput "${_1}" || true
	dye_puts "${*-}"
	dye_split tput "${_2}" || true
)

dye_color() (
	case "$1" in
	black) echo 0 ;;
	red) echo 1 ;;
	green) echo 2 ;;
	yellow) echo 3 ;;
	blue) echo 4 ;;
	magenta) echo 5 ;;
	cyan) echo 6 ;;
	white | brightgray) echo 7 ;;
	gray) echo 8 ;;
	bright*)
		base="$(dye_color "${1##*bright}")"
		echo "$((8 + base))"
		;;
	'' | *[!0-9]*) return 1 ;;
	*) echo "$1" ;;
	esac
)

dye_synth() {
	if [ "${DYE_COLORS-}" = "8" ] && [ "$1" -ge 8 ] && [ "$1" -le 15 ]; then
		echo $(($1 - 8))
		return 1
	fi
	echo "$1"
}

dye_render() (
	b="$1"
	while [ -n "${b}" ]; do
		case "${b}" in
		\\[\\\{]*)
			p="${b#\\}"
			b="${p#?}"
			p="${p%"${b}"}"
			dye_puts "${p}"
			;;
		\{\{*)
			p="${b#\{\{}"
			b="${p#*\}\}}"
			p="${p%%\}\}*}"
			dye_split dye "${p}"
			;;
		*)
			s1="${b%%\{\{*}"
			s2="${b%%\\[\\\{]*}"
			if [ "${s1}" = "${s2}" ]; then
				b=""
				dye_puts "${s1}"
				break
			fi
			if [ ${#s1} -lt ${#s2} ]; then
				b="{{${b#*\{\{}"
				dye_puts "${s1}"
			else
				b="\\${b#*\\}"
				dye_puts "${s2}"
			fi
			;;
		esac
	done
)

dye() {
	if [ "$1" = "setup" ]; then
		shift
		dye_detect "${@-}" && DYE_COLORS="$(tput colors)"
		return 0
	fi

	(
		_1="$1"
		shift
		case "${_1}" in
		p | print)
			dye_render "${@-}"
			printf "\n"
			;;
		write)
			dye_render "${@-}"
			;;
		fg)
			c="$(dye_color "$1")" || return
			c="$(dye_synth "${c}")" || dye_out bold
			shift
			dye_out "setaf ${c}" "sgr0" "${@-}"
			;;
		bg)
			c="$(dye_color "$1")" || return
			c="$(dye_synth "${c}")" || true
			shift
			dye_out "setab ${c}" "sgr0" "${@-}"
			;;
		dim) dye_out "dim" "sgr0" "${@-}" ;;
		bold) dye_out "bold" "sgr0" "${@-}" ;;
		reverse) dye_out "rev" "sgr0" "${@-}" ;;
		reset) dye_out "sgr0" ;;
		i | italic) dye_out "sitm" "ritm" "${@-}" ;;
		so | standout) dye_out "smso" "rmso" "${@-}" ;;
		u | ul | underline) dye_out "smul" "rmul" "${@-}" ;;
		begin) dye "${@-}" ;;
		end)
			case "$1" in
			i | italic) dye_out "ritm" ;;
			so | standout) dye_out "rmso" ;;
			u | ul | underline) dye_out "rmul" ;;
			*) return 1 ;;
			esac
			;;
		*)
			dye fg "${_1}" "${@-}"
			;;
		esac
	)
}
