# Dagger JVM
This is a sample project that shows how to build a JVM project with Dagger.
In this case this will be a "Hello World" Ktor application (it doesn't really matter).

## Setup
To setup dagger, [install it](https://docs.dagger.io/1200/local-dev).
In our case, to avoid polluting our project structure, we will do it in a separate directory ([/dagger]).
So 
```sh
    mkdir dagger
    cd dagger
    dagger project init # Inits the project
    dagger project update # Download the dependencies
```
And now you have an empty dagger project !

## Building a java project in Dagger
Now that we have an empty project, we can start to write our first cue lines.
TODO: Explain what is CUE
What we are doing in reality is building our gradle project in a docker container.
To do this, we are using the `docker.#Run` action from the dagger `universe`.
This is a set of actions not maintained directly by the team but that are stable enough to be shared with the whole community.
TODO: Explain what we do exactly.
