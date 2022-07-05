package main

// Those are actions that you can import
import (
	"dagger.io/dagger",
	"universe.dagger.io/docker"
)

dagger.#Plan & {
	client: {
		filesystem:{
			"..": {
				read: {
					contents: dagger.#FS
				}
			}
			// output: write: contents: actions.build.output // Try that next ?
		}
	}

	actions: {
		build: docker.#Run & {
			_container: docker.#Pull & {
				source: "eclipse-temurin:17-jdk-alpine" // PERF: use a gradle image to speed up build
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
			// TODO: This does not work, file not found :( Is there a way to inspect what's in there ?
			// export: files: "/app/build/libs/dagger-jvm-0.0.1.jar": bytes
		}
	}
}
