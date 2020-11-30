#!/usr/bin/env bash
# shellcheck disable=SC2154

#
# ARG_OPTIONAL_SINGLE([output-directory],[o],[Specify output directory],[.])
# ARG_OPTIONAL_SINGLE([start],[s],[specify the start],[00:00:00])
# ARG_POSITIONAL_SINGLE([input],[path to input video])
# ARG_POSITIONAL_SINGLE([end],[target end timestemp of the video])
# ARG_HELP([ffmpeg wrapper to trim a video to a desired timestemp without recompressing (simple copy)\n  Example: ./trim.sh ./ollech/Hi8_kinder_ollech_1_2020-11-29_12-07-20_crf-18.mp4 00:37:44 -s 00:15:26 -o ./ollech_trim])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.10.0 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info


die()
{
	local _ret="${2:-1}"
	test "${_PRINT_HELP:-no}" = yes && print_help >&2
	echo "$1" >&2
	exit "${_ret}"
}


begins_with_short_option()
{
	local first_option all_short_options='osh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
_positionals=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_output_directory="."
_arg_start="00:00:00"


print_help()
{
	printf '%s\n' "ffmpeg wrapper to trim a video to a desired timestemp without recompressing (simple copy)
  Example: ./trim.sh ./ollech/Hi8_kinder_ollech_1_2020-11-29_12-07-20_crf-18.mp4 00:37:44 -s 00:15:26 -o ./ollech_trim"
	printf 'Usage: %s [-o|--output-directory <arg>] [-s|--start <arg>] [-h|--help] <input> <end>\n' "$0"
	printf '\t%s\n' "<input>: path to input video"
	printf '\t%s\n' "<end>: target end timestemp of the video"
	printf '\t%s\n' "-o, --output-directory: Specify output directory (default: '.')"
	printf '\t%s\n' "-s, --start: specify the start (default: '00:00:00')"
	printf '\t%s\n' "-h, --help: Prints help"
}


parse_commandline()
{
	_positionals_count=0
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-o|--output-directory)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_output_directory="$2"
				shift
				;;
			--output-directory=*)
				_arg_output_directory="${_key##--output-directory=}"
				;;
			-o*)
				_arg_output_directory="${_key##-o}"
				;;
			-s|--start)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_start="$2"
				shift
				;;
			--start=*)
				_arg_start="${_key##--start=}"
				;;
			-s*)
				_arg_start="${_key##-s}"
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_last_positional="$1"
				_positionals+=("$_last_positional")
				_positionals_count=$((_positionals_count + 1))
				;;
		esac
		shift
	done
}


handle_passed_args_count()
{
	local _required_args_string="'input' and 'end'"
	test "${_positionals_count}" -ge 2 || _PRINT_HELP=yes die "FATAL ERROR: Not enough positional arguments - we require exactly 2 (namely: $_required_args_string), but got only ${_positionals_count}." 1
	test "${_positionals_count}" -le 2 || _PRINT_HELP=yes die "FATAL ERROR: There were spurious positional arguments --- we expect exactly 2 (namely: $_required_args_string), but got ${_positionals_count} (the last one was: '${_last_positional}')." 1
}


assign_positional_args()
{
	local _positional_name _shift_for=$1
	_positional_names="_arg_input _arg_end "

	shift "$_shift_for"
	for _positional_name in ${_positional_names}
	do
		test $# -gt 0 || break
		eval "$_positional_name=\${1}" || die "Error during argument parsing, possibly an Argbash bug." 1
		shift
	done
}

parse_commandline "$@"
handle_passed_args_count
assign_positional_args 1 "${_positionals[@]}"

# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash


#Check if input directory exits
if [ ! -d "$_arg_output_directory" ]
then
  echo "output directory must exist"
  exit 1
fi

#Get filename withou extension
filename="$(basename $_arg_input | sed 's/\(.*\)\..*/\1/')_trim"

#Get filename extension
extension=".${_arg_input##*.}"

#Build file output path
output="$_arg_output_directory/$filename$extension"

if [ "$_arg_start" = 00:00:00 ]
then
    #No start trim was specified -> trim end
    ffmpeg -i $_arg_input -to $_arg_end -c:v copy -c:a copy -avoid_negative_ts make_zero $output
else
    #Start trim was specified -> trim start and end
    ffmpeg -ss $_arg_start -i $_arg_input -to $_arg_end -c:v copy -c:a copy -avoid_negative_ts make_zero $output
fi

echo
echo "Video written to $output"

# ] <-- needed because of Argbash
