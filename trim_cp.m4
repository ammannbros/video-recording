#!/usr/bin/env bash
# shellcheck disable=SC2154

#
# ARG_OPTIONAL_SINGLE([output_directory], o, [Specify output directory], [.])
# ARG_OPTIONAL_SINGLE([output_filename], f, [Specifys a filename])
# ARG_OPTIONAL_SINGLE([start], s, [specify the start], [00:00:00])
# ARG_POSITIONAL_SINGLE([input], [path to input video])
# ARG_POSITIONAL_SINGLE([end], [target end timestemp of the video])
# ARG_HELP([ffmpeg wrapper to trim a video to a desired timestemp without recompressing (simple copy)\n])
# ARGBASH_GO

# [ <-- needed because of Argbash

#Check if input directory exits
if [ ! -d "$_arg_output_directory" ] 
then
  echo "output directory must exist"
  exit 1
fi

if [[ -z "$_arg_output_filename" ]] 
then
    #Get filename withou extension from input filename
    filename="$(basename $_arg_input | sed 's/\(.*\)\..*/\1/')_trim"
else
    #Use specified output filename
    filename="$_arg_output_filename"
fi

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
