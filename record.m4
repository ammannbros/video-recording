#!/usr/bin/env bash
# shellcheck disable=SC2154

#
# ARG_OPTIONAL_SINGLE([duration], d, [Duration of recording], [02:00:00])
# ARG_OPTIONAL_SINGLE([output-directory], o, [Specify output directory], [.])
# ARG_OPTIONAL_SINGLE([crf], , [crf to use for encoding], [18])
# ARG_OPTIONAL_BOOLEAN([preview], , [do not show a live preview], off)
# ARG_POSITIONAL_SINGLE([id], [the id of the video recording], )
# ARG_HELP([Script to record from a Stk1160 based USB 2.0 video and audio capture device])
# ARGBASH_GO

# [ <-- needed because of Argbash

id=$_arg_id

if [ -z "$id" ]
then
  echo "id can not be empty"
  exit 1
fi

crf=$_arg_crf

today=$(date '+%Y-%-m-%d_%H-%M-%S');
title="${id}_${today}_crf-${crf}"
input=$_arg_input
output_directory=$_arg_output_directory

if [ ! -d "$output_directory" ] 
then
  echo "output directory must exist"
  exit 1
fi

output="$output_directory/$title.mp4"
log_file="$output_directory/$title.log"

ffmpeg_program=$(cat <<ENDFFMPEG
  ffmpeg -f v4l2 -standard PAL -thread_queue_size 2048 -i /dev/video0 \
    -f alsa -thread_queue_size 2048 -i hw:2,0 \
    -vf "yadif=1" \
    -c:v libx264 -crf:v "$crf" -preset:v slow -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    -movflags +faststart -r 25 \
    -t $_arg_duration \
    -metadata author="Familie Ammann" \
    -metadata title="$title" \

ENDFFMPEG
)
  
echo "$_arg_preview"
  
if [ "$_arg_preview" = on ] 
then
  ffmpeg_program="$ffmpeg_program $output -vf format=yuv420p -f sdl Preview |& tee $log_file"
else
  ffmpeg_program="$ffmpeg_program $output |& tee $log_file"
fi

echo "$ffmpeg_program"
eval "$ffmpeg_program |& tee $log_file"

echo "Video written to $output"
  
# ] <-- needed because of Argbash
