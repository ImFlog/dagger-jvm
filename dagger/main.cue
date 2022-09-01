package main

// Those are actions that you can import
import (
	"dagger.io/dagger",
	"universe.dagger.io/docker"
)

dagger.#Plan & {
	client: {
		env: REGISTRY_TOKEN: dagger.#Secret
		filesystem:{
			"..": {
				read: {
					contents: dagger.#FS
					exclude: ["build"]
				}
			}
		}
	}

	actions: {
		lint: docker.#Run & {
			_built_container: docker.#Build & {
				steps: [
					docker.#Pull & {
						source: "gradle:jdk17"
					},
					docker.#Set & {
						config: workdir: "/app"
					},
					docker.#Copy & {
						contents: client.filesystem."..".read.contents
					}
				]
			}
			input: _built_container.output
			command: {
				name: "gradle"
				args: ["ktlintCheck"]
			}
		}
		test: docker.#Run & {
			// As the FS is retrieved from previous step,
			// The gradle cache is persisted :)
			input: lint.output
			command: {
				name: "gradle"
				args: ["test"]
			}
		}
		build: docker.#Run & {
			input: test.output
			command: {
				name: "gradle"
				args: ["build"]
			}
		}
		push: docker.#Push & {
			_image: docker.#Build & {
				steps: [
					docker.#Pull & {
						source: "eclipse-temurin:17-jdk"
					},
					docker.#Copy & {
						// Here we copy the build rootfs to get the /app/build directory
						contents: build.output.rootfs
					},
					docker.#Set & {
						config: {
							cmd: ["java", "-jar", "/app/build/libs/dagger-jvm-0.0.1.jar"]
						}
					}
				]
			}
			image: _image.output
			auth: {
				username: "flotech"
				secret: client.env.REGISTRY_TOKEN
			}
			dest: "flotech/dagger-jvm:0.0.1"
		}
	}
}
