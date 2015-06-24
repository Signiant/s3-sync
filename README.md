# s3-sync
Syncs multiple paths from S3 with the local container (or host datavolume)

## Variables

- VERBOSE - enable more logging if set to 1
- FREQUENCY - How often to sync from S3 (in seconds). Default is 300 seconds.

## Config format
The tool to sync the S3 paths reads a config file containing the S3 folder and the local path to sync it to.  The format is as follows:

````
( [s3]=S3BUCKET/folder [local]=/my/local/path1 )
( [s3]=S3BUCKET/folder2 [local]=/my/local/path2 )
````

Each S3/local path pair should be on a seperate line.

## Example Docker runs

### On AWS (uses role credentials)

This example mounts the file paths.dat on the docker host into /paths.dat in the container and then passes that as the argument to the s3 sync tool.

````
docker run -d -e "FREQUENCY=600"			\
		-e "VERBOSE=1"				\
		-v mylocaldir/paths.dat:/paths.dat	\
		signiant/s3-sync			\
		/paths.dat
````

### Outside AWS (needs access/secret key)

This example mounts the file paths.dat on the docker host into /paths.dat in the container and then passes that as the argument to the s3 sync tool.

````
docker run -d 	-e "FREQUENCY=600"			\
		-e "VERBOSE=1"				\
		-e "AWS_ACCESS_KEY_ID=MY_ACCESS_KEY	\
		-e "AWS_SECRET_ACCESS_KEY=MY_SECRET	\
		-v mylocaldir/paths.dat:/paths.dat	\
		signiant/s3-sync			\
		/paths.dat
````

