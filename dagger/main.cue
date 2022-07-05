package main

// Those are actions that you can import
import (
	"dagger.io/dagger",
	"universe.dagger.io/docker"
)

client: {
		filesystem:{
			"..": { // TODO: Explain this (we need to parent FS as we are in a subdirectory)
				read: {
					contents: dagger.#FS
				}
			}
		}
}

dagger.#Plan & {
	actions: {
		build: docker.#Run & {
			_container: docker.#Pull & {
				source: "eclipse-temurin:17-jdk-alpine"
			}
			input: _container.output
			mounts: {
				root: {
					dest: "/app"
					contents: client.filesystem."..".read.contents
					type: "fs"
				}
			}
			workdir: "/app"
			command: {
				name: "./gradlew"
				args: ["build"]
			}
		}
	}
}
