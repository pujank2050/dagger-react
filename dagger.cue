package main

import (
    "dagger.io/dagger"
    "gitlab.com/hazelcomb/swordcoat/test"
)

dagger.#Plan & {
    client: {
        filesystem: project: read: {  
            path: "."  
            contents: dagger.#FS
            exclude: [
                ".vscode",
                "cue.mod",
                "opt",
                ".gitlab-ci.yml",
                "example.cue",
                "LICENSE",
                "README"
            ]
        }
        network: {
            unixDocker: {
                address: "unix:///var/run/docker.sock"
                connect: dagger.#Socket
            }
            windowsDocker: {
                address: "npipe:////./pipe/docker_engine"
                connect: dagger.#Socket
            }
        }
    }

    actions: {
        init: test.#Environment & {
            src: client.filesystem.project.read.contents
        }

        windows: test.#Run & {
            socket: client.network.windowsDocker.connect
            input: init.image.output
            variables: init.variables
            src: init.source.output
        }

        unix: test.#Run & {
            socket: client.network.unixDocker.connect
            input: init.image.output
            variables: init.variables
            src: init.source.output
        }
    }
}
