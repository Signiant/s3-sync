#!/bin/bash

FOLDERS_MAP_FILE=$1

declare -A folders

# Set a default frequency of 300 seconds if not set in the env
if [ -z "$FREQUENCY" ]; then
	FREQUENCY=300
fi

echo "Verbose is $VERBOSE"
echo "Frequency is $FREQUENCY"
 
# Loop forever, sleeping for our frequency
while true
do
	echo "Awoke to process paths from $FOLDERS_MAP_FILE"
	
	# Read in the folders from the input file
	while read -r line; do
		declare -A folders="$line"

		echo "Syncing S3:${folders[s3]} => local:${folders[local]}"
		
		if [ ! -d "${folders[local]}" ]; then
			echo "local folder ${folders[local]} does not exist - creating"
			mkdir -p "${folders[local]}"
		fi

		CMD="aws s3 sync s3://${folders[s3]} ${folders[local]}"
		
		if [ $VERBOSE == 1 ]; then
			echo "Sync command: ${CMD}"
		fi
		
		OUTPUT=$($CMD)
		
		if [ $VERBOSE == 1 ]; then
			echo $OUTPUT
		fi
		
		if [[ $OUTPUT == *"download"* ]]; then
			echo "New/Changed files were downloaded - setting marker"
			touch ${folders[local]}/NEWCONTENT
		else
			echo "No new/changed files were downloaded"
		fi
	done < ${FOLDERS_MAP_FILE}
	
	echo "Sleeping for $FREQUENCY seconds"
	sleep $FREQUENCY
done

exit 0

