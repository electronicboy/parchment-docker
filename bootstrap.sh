#!/usr/bin/env bash

#borrowed from paper, use printf as it's more compatible
color() {
    if [ $2 ]; then
            printf "\e[$1;$2m"
    else
            printf "\e[$1m"
    fi
}
colorend() {
    printf "\e[m"
}

if [ ! -f "server.jar" ]; then
    if [ -z "$project" ]; then
        # default project to paper
        project="paper"
    fi

    # if the version env variable isn't set, or set to latest, go lookup latest
    if [ -z "$version" ] || [ "$version" = "latest" ]; then
        parchmentjson=$(curl -s https://papermc.io/api/v1/$project)
        
        error=$(echo $parchmentjson | jq .error)

        if [ ! "null" = "$error" ]; then
            echo "$(color 31)An error has occured while looking for project information for $project$(colorend)"
            echo "$error"
            exit 1
        fi

        version=$(echo $parchmentjson | jq .versions[0] | sed s\#\"\#\#g)
    fi

    # if no build is set, lets assume we want the latest
    if [ -z $build ] || [ "$build" = "latest"]; then
        build=latest
    fi

    parchmentVersionJson=$(curl -s https://papermc.io/api/v1/$project/$version/$build)

        error=$(echo $parchmentVersionJson | jq .error)

    if [ ! "null" = "$error" ]; then
        echo "$(color 31)An error has occured while fetching project $project:$version($build)$(colorend)"
        echo "$error"
        exit 1
    fi

    #resolve a real build number
    if [ "$build" = "latest" ]; then 
        build=$(echo $parchmentVersionJson | jq .build | sed s\#\"\#\#g)
    fi

    echo "$(color 33)fetching $project:$version($build) from parchment$(colorend)"

    curl https://papermc.io/api/v1/$project/$version/$build/download >server.jar
fi

if [ ! -d "root" ]; then
    mkdir root
fi

cd root

if [ ! -z "$eula" ]; then
    echo "eula=true" >eula.txt
    pwd
fi

echo "$(color 32)Starting $project$(colorend)"

java ${jvm_args:--Xmx1G} -jar ../server.jar
if [ ! $? = 0 ]; then
    echo "$(color 31)The server stopped unexpectidly, if the jar is corrupted, please rebuild the container$(colorend)"
fi
