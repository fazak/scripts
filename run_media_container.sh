# Use this script to run container with access to to host GPU and GUI interface (even on ssh)
# usage: ./run_media_container.sh container_name

xhost +local:docker
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
docker run -it --rm --net=host --privileged \
    -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTH \
    --device /dev/dri \
    -v /dev/dri:/dev/dri -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH \
    -v ~:/host_home \
    -w /host_home \
    --entrypoint bash $1
xhost -local:docker
