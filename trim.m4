#!/usr/bin/env bash
# shellcheck disable=SC2154

#
# ARG_OPTIONAL_SINGLE([output-directory], o, [Specify output directory], [.])
# ARG_OPTIONAL_SINGLE([start], s, [specify the start], [00:00:00])
# ARG_POSITIONAL_SINGLE([input], [path to input video])
# ARG_POSITIONAL_SINGLE([end], [target end timestemp of the video])
# ARG_HELP([ffmpeg wrapper to trim a video to a desired timestemp without recompressing (simple copy)\n  Example: ./trim.sh ./ollech/Hi8_kinder_ollech_1_2020-11-29_12-07-20_crf-18.mp4 00:37:44 -s 00:15:26 -o ./ollech_trim])
# ARGBASH_GO

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
    ffmpeg -i $_arg_input -to $_arg_end -c:v copy -c:a copy $output
else
    #Start trim was specified -> trim start and end 
    ffmpeg -i $_arg_input -ss $_arg_start -to $_arg_end -c:v copy -c:a copy $output
fi

echo 
echo "Video written to $output"

# ] <-- needed because of Argbash
