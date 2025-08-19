# shellcheck shell=sh disable=SC2034,SC2329

Describe "dye_out"
    Include "./dye.sh"

    Example "only prints third argument if DYE_COLORS is unset"
        tput() {
            called=1
            %preserve called
        }

        unset DYE_COLORS
        When call dye_out "setaf 1" "sgr0" "red text"
        The variable called should be undefined
        The output should equal "red text"
    End

    Example "calls tput once if DYE_COLORS is set and no text is present"
        tput() {
            arg1="$1"
            arg2="${2-}"
            %preserve arg1 arg2
        }

        DYE_COLORS=256
        When call dye_out "setaf 1" "sgr0"
        The variable arg1 should equal "setaf"
        The variable arg2 should equal "1"
    End

    Example "outputs start sequence, text, and end sequence if DYE_COLORS is set and text is present"
        tput() {
            test "$1" = "setaf" -a "${2-}" = "1" && printf "%s" "!RED!" && return 0
            test "$1" = "sgr0" && printf "%s" "!RESET!" && return 0
            return 1
        }

        DYE_COLORS=256
        When call dye_out "setaf 1" "sgr0" "red text"
        The output should equal "!RED!red text!RESET!"
    End
End